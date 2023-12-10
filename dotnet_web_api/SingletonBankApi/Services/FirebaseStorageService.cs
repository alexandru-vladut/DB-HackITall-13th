using Google.Cloud.Storage.V1;
using Microsoft.AspNetCore.Mvc;
using SingletonBank.Interfaces;

namespace SingletonBank.Services
{
    public class FirebaseStorageService : IFirebaseStorageService
    {
        private readonly StorageClient _storageClient;
        private const string BucketName = "codemaze-firebase.appspot.com";

        public FirebaseStorageService(StorageClient storageClient)
        {
            _storageClient = storageClient;
        }

        public async Task<Uri> UploadFile(string name, [FromForm] IFormFile file)
        {
            if (file == null)
            {
                throw new ArgumentNullException(nameof(file), "No file provided");
            }

            var randomGuid = Guid.NewGuid();

            using var stream = new MemoryStream();

            if (file.Length > 0)
            {
                // Ensure the stream is at the beginning
                stream.Seek(0, SeekOrigin.Begin);

                await file.CopyToAsync(stream);
                stream.Seek(0, SeekOrigin.Begin); // Reset the stream position after copying
            }
            else
            {
                // Handle the case where the file has no content
                throw new ArgumentException("File has no content", nameof(file));
            }

            var blob = await _storageClient.UploadObjectAsync(BucketName, $"{name}-{randomGuid}", file.ContentType, stream);

            var photoUri = new Uri(blob.MediaLink);

            return photoUri;
        }
    }
}
