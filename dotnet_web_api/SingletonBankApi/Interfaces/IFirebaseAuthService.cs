using FirebaseAdmin.Auth;

namespace SingletonBank.Interfaces
{
    public interface IFirebaseAuthService
    {
        public Task<string?> SignUp(string name, string email, string password);
        public Task<string?> Login(string email, string password);
        public void SignOut();
        public FirebaseToken VerifyToken(string token);
    }
}
