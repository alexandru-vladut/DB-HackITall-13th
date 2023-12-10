using System.ComponentModel.DataAnnotations;

namespace SingletonBank.DTOs
{
    public class UserDto
    {
        [Required, EmailAddress]
        public required string Email { get; set; }
        [Required]
        public required string Password { get; set; }
    }
}
