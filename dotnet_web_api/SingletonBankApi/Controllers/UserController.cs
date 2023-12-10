using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Mvc;
using SingletonBank.DTOs;
using SingletonBank.Interfaces;
using SingletonBankApi.Authentication.Classes;

namespace SingletonBankApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly IFirebaseAuthService _authService;


        public UserController(IFirebaseAuthService authService)
        {
            _authService = authService;
        }


        [HttpPost("register")]
        public async Task<IActionResult> AddUser(SignUpUserDto signUpUserDto)
        {

            string? token;
            try
            {
                token = await _authService.SignUp(signUpUserDto.Name, signUpUserDto.Email, signUpUserDto.Password);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            var bearerToken = new Authentication.Classes.BearerToken
            {
                Value = token
            };


            return Ok(bearerToken);
        }


        [HttpPost("login")]
        public async Task<IActionResult> Login(UserDto userDto)
        {
            string? token;
            try
            {
                token = await _authService.Login(userDto.Email, userDto.Password);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            var bearerToken = new Authentication.Classes.BearerToken
            {
                Value = token
            };

            return Ok(bearerToken);
        }


        [HttpGet("validateToken")]
        public IActionResult ValidateToken(string token)
        {
            var result = _authService.VerifyToken(token);

            return Ok(result);
        }
    }
}
