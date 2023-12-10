using Microsoft.AspNetCore.Mvc;
using SingletonBank.DTOs;
using SingletonBank.Models;
using SingletonBankApi.DTOs;
using SingletonBankApi.Interfaces;
using SingletonBankApi.Models;

namespace SingletonBankApi.Controllers
{
    //[Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class VendorController : ControllerBase
    {
        private readonly IFirestoreVendorService _firestoreVendorService;

        public VendorController(IFirestoreVendorService firestoreVendorService)
        {
            _firestoreVendorService = firestoreVendorService;
        }


        [HttpGet("getAllVendors")]
        public async Task<IActionResult> GetAll()
        {
            List<Vendor> vendors;

            try
            {
                vendors = await _firestoreVendorService.GetAll();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }


            return Ok(vendors);
        }


        [HttpPost("addVendor")]
        public async Task<IActionResult> AddVendor(VendorDto vendorDto)
        {
            try
            {
                await _firestoreVendorService.AddAsync(new Vendor
                {
                    Name = vendorDto.Name,
                    CashBack = vendorDto.CashBack,
                    Category = vendorDto.Category,
                    EcoFriendly = vendorDto.EcoFriendly,
                });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }


            return Ok(vendorDto);
        }

        [HttpPut("updateVendor")]
        public async Task<IActionResult> UpdateVendor(VendorDto vendorDto, string vendorId)
        {
            try
            {
                await _firestoreVendorService.UpdateAsync(new Vendor
                {
                    Name = vendorDto.Name,
                    CashBack = vendorDto.CashBack,
                    Category = vendorDto.Category,
                    EcoFriendly = vendorDto.EcoFriendly,
                }, vendorId);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Ok(vendorDto);
        }



        [HttpDelete("deleteVendorById")]
        public async Task<IActionResult> DeleteVendor(string vendorId)
        {
            try
            {
                await _firestoreVendorService.DeleteAsync(vendorId);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Ok($"Vendor with id {vendorId} deleted with success!");
        }
    }
}
