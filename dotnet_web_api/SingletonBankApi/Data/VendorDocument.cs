using Google.Cloud.Firestore;

namespace SingletonBankApi.Data
{
    [FirestoreData]
    public class VendorDocument
    {
        [FirestoreDocumentId]
        public required string Id { get; set; }

        [FirestoreProperty]
        public required string Name { get; set; }

        [FirestoreProperty]
        public required float CashBack { get; set; }

        [FirestoreProperty]
        public required string Category { get; set; }

        [FirestoreProperty]
        public required bool EcoFriendly { get; set; }

    }
}
