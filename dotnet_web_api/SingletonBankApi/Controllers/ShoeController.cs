using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SingletonBank.DTOs;
using SingletonBank.Interfaces;
using SingletonBank.Models;

namespace SingletonBankApi.Controllers
{
    //[Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class ShoeController : ControllerBase
    {
        private readonly IFirestoreShoeService _firestoreShoeService;
        private readonly IFirebaseStorageService _storageService;


        public ShoeController(IFirestoreShoeService firestoreShoeService, IFirebaseStorageService storageService)
        {
            _firestoreShoeService = firestoreShoeService;
            _storageService = storageService;
        }


        [HttpGet("getAllShoes")]
        public async Task<IActionResult> GetAllShoes() 
        {
            var shoes = await _firestoreShoeService.GetAll();

            return Ok(shoes);
        }



        [HttpPost("addShoe")]
        public async Task<IActionResult> AddShoe(ShoeDto shoeDto)
        {
            try
            {
                await _firestoreShoeService.AddAsync(new Shoe
                {
                    Name = shoeDto.Name,
                    Brand = shoeDto.Brand,
                    Price = shoeDto.Price
                });
            } 
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }


            return Ok(shoeDto);
        }


        [HttpDelete("deleteShoeById")]
        public async Task<IActionResult> DeleteShoe(string shoeId)
        {
            try
            {
                await _firestoreShoeService.DeleteAsync(shoeId);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Ok($"Shoe with id {shoeId} deleted with success!");
        }
    }
}
