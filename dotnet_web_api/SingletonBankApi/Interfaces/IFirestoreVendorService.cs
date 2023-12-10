using SingletonBank.Models;
using SingletonBankApi.Models;

namespace SingletonBankApi.Interfaces
{
    public interface IFirestoreVendorService
    {
        public Task<List<Vendor>> GetAll();
        public Task AddAsync(Vendor vendor);
        public Task UpdateAsync(Vendor vendor, string vendorId);
        public Task DeleteAsync(string vendorId);
    }
}
