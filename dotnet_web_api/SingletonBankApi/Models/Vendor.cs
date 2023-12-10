namespace SingletonBankApi.Models
{
    public class Vendor
    {
        public string Id { get; set; }
        public required string Name { get; set; }
        public required float CashBack {  get; set; }
        public required string Category { get; set; }
        public required bool EcoFriendly { get; set; }
    }
}
