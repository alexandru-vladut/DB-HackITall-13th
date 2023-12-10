using SingletonBank.Models;

namespace SingletonBank.Interfaces
{
    public interface IFirestoreShoeService
    {
        public Task<List<Shoe>> GetAll();

        public Task AddAsync(Shoe shoe);

        public Task DeleteAsync(string shoeId);
    }
}
