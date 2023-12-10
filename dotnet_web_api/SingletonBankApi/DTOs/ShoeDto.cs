using System.ComponentModel.DataAnnotations;

namespace SingletonBank.DTOs
{
    public class ShoeDto
    {
        [Required]
        public required string Name { get; set; }
        [Required]
        public required string Brand { get; set; }
        [Required]
        public required decimal Price { get; set; }

        //[Required]
        //public required IFormFile Image { get; set; }
    }
}
