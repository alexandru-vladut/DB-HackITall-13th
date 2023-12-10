namespace SingletonBank.Models
{
    public class Shoe
    {
        public string Id { get; set; }

        public required string Name { get; set; }

        public required string Brand { get; set; }

        public decimal Price { get; set; }

        //public Uri ImageUri { get; set; } = default!;
    }
}
