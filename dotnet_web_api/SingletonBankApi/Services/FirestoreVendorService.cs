using Google.Cloud.Firestore;
using SingletonBank.Data;
using SingletonBank.Models;
using SingletonBankApi.Data;
using SingletonBankApi.Interfaces;
using SingletonBankApi.Models;

namespace SingletonBankApi.Services
{
    public class FirestoreVendorService : IFirestoreVendorService
    {
        private readonly FirestoreDb _firestoreDb;
        private const string _collectionName = "Vendors";

        public FirestoreVendorService(FirestoreDb firestoreDb)
        {
            _firestoreDb = firestoreDb;
        }

        public async Task AddAsync(Vendor vendor)
        {
            var collection = _firestoreDb.Collection(_collectionName);
            var vendorDocument = ConvertModelToDocument(vendor);
            await collection.AddAsync(vendorDocument);
        }

        public async Task DeleteAsync(string vendorId)
        {
            var collection = _firestoreDb.Collection(_collectionName);
            DocumentReference docRef = collection.Document(vendorId);

            await docRef.DeleteAsync();
        }

        public async Task<List<Vendor>> GetAll()
        {
            var collection = _firestoreDb.Collection(_collectionName);
            var snapshot = await collection.GetSnapshotAsync();

            var vendorDocuments = snapshot.Documents.Select(s => s.ConvertTo<VendorDocument>()).ToList();
            return vendorDocuments.Select(ConvertDocumentToModel).ToList();
        }


        private static Vendor ConvertDocumentToModel(VendorDocument vendorDocument)
        {
            return new Vendor
            {
                Id = vendorDocument.Id,
                Name = vendorDocument.Name,
                CashBack = vendorDocument.CashBack,
                Category = vendorDocument.Category,
                EcoFriendly = vendorDocument.EcoFriendly,
            };
        }
        private static VendorDocument ConvertModelToDocument(Vendor vendor)
        {
            return new VendorDocument
            {
                Id = vendor.Id,
                Name = vendor.Name,
                CashBack = vendor.CashBack,
                Category = vendor.Category,
                EcoFriendly = vendor.EcoFriendly,
            };
        }

        public async Task UpdateAsync(Vendor vendor, string vendorId)
        {
            var collection = _firestoreDb.Collection(_collectionName);
            DocumentReference docRef = collection.Document(vendorId);

            Dictionary<string, object> updates = new Dictionary<string, object>
            {
                { "Name", vendor.Name },
                { "Cashback", vendor.CashBack },
                { "Category", vendor.Category },
                { "EcoFriendly", vendor.EcoFriendly }
            };

            await docRef.UpdateAsync(updates);
        }
    }
}
