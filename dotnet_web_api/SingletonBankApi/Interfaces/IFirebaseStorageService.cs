namespace SingletonBank.Interfaces
{
    public interface IFirebaseStorageService
    {
        public Task<Uri> UploadFile(string name, IFormFile file);
    }
}
