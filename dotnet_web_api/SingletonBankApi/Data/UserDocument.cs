using Google.Cloud.Firestore;

namespace SingletonBankApi.Data
{
    [FirestoreData]
    public class UserDocument
    {
        [FirestoreDocumentId]
        public required string Id { get; set; }

        [FirestoreProperty]
        public required string Name { get; set; }

        [FirestoreProperty]
        public required string Email { get; set; }

        [FirestoreProperty]
        public required string Uid { get; set; }

    }
}
