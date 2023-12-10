using FirebaseAdmin.Auth;
using Google.Cloud.Firestore;
using SingletonBank.Interfaces;
using static Google.Rpc.Context.AttributeContext.Types;
using System.Xml.Linq;
using SingletonBank.Data;
using SingletonBank.Models;
using SingletonBankApi.Data;
using SingletonBankApi.Models;
using Firebase.Auth;

namespace SingletonBank.Services
{
    public class FirebaseAuthService : IFirebaseAuthService
    {
        private readonly FirebaseAuthClient _firebaseAuth;
        private readonly FirestoreDb _firestoreDb;
        private const string _collectionName = "webUsers";

        public FirebaseAuthService(FirebaseAuthClient firebaseAuth, FirestoreDb firestoreDb)
        {
            _firebaseAuth = firebaseAuth;
            _firestoreDb = firestoreDb;
        }

        public async Task<string?> SignUp(string name, string email, string password)
        {
            var userCredentials = await _firebaseAuth.CreateUserWithEmailAndPasswordAsync(email, password);

            await CreateFirestoreUserDocument(userCredentials.User.Uid, name, email);

            return userCredentials is null ? null : await userCredentials.User.GetIdTokenAsync();
        }
        public async Task<string?> Login(string email, string password)
        {
            var userCredentials = await _firebaseAuth.SignInWithEmailAndPasswordAsync(email, password);
            return userCredentials is null ? null : await userCredentials.User.GetIdTokenAsync();
        }

        public void SignOut() => _firebaseAuth.SignOut();


        public FirebaseToken VerifyToken(string token)
        {
            try
            {
                return FirebaseAuth.DefaultInstance.VerifyIdTokenAsync(token).Result;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Token verification failed: {ex.Message}");
                return null;
            }
        }


        private async Task CreateFirestoreUserDocument(string userId, string name, string email)
        {
            CollectionReference usersCollection = _firestoreDb.Collection(_collectionName);

            var user = new UserModel
            {
                Name = name,
                Email = email,
                Uid = userId
            };

            var userDocument = ConvertModelToDocument(user);

            await usersCollection.AddAsync(userDocument);
        }


        private static UserModel ConvertDocumentToModel(UserDocument userDocument)
        {
            return new UserModel
            {
                Id = userDocument.Id,
                Name = userDocument.Name,
                Email = userDocument.Email,
                Uid = userDocument.Uid,
            };
        }

        private static UserDocument ConvertModelToDocument(UserModel user)
        {
            return new UserDocument
            {
                Id = user.Id,
                Uid = user.Uid,
                Name = user.Name,
                Email = user.Email
            };
        }
    }
}
