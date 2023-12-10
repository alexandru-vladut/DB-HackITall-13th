using System.ComponentModel.DataAnnotations;

namespace SingletonBank.DTOs
{
    public class SignUpUserDto
    {
        [Required]
        public required string Name { get; set; }
        [Required, EmailAddress]
        public required string Email { get; set; }
        [Required]
        public required string Password { get; set; }
        [Required, Compare(nameof(Password), ErrorMessage = "The passwords didn't match.")]
        public required string ConfirmPassword { get; set; }
    }
}
