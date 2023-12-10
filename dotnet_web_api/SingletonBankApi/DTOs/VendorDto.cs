using System.ComponentModel.DataAnnotations;

namespace SingletonBankApi.DTOs
{
    public class VendorDto
    {
        [Required]
        public required string Name { get; set; }
        [Required]
        public required float CashBack { get; set; }
        [Required]
        public required string Category { get; set; }
        [Required]
        public required bool EcoFriendly { get; set; }
    }
}
