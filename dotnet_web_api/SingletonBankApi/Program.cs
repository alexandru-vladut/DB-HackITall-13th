using Firebase.Auth.Providers;
using Firebase.Auth;
using Google.Cloud.Firestore;
using SingletonBank.Interfaces;
using SingletonBank.Services;
using Google.Cloud.Storage.V1;
using FirebaseAdmin;
using Microsoft.OpenApi.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using SingletonBankApi.Interfaces;
using SingletonBankApi.Services;

var builder = WebApplication.CreateBuilder(args);

var firebaseProjectName = "hackitall-singleton";

// Add services to the container.

builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition("oauth2", new OpenApiSecurityScheme
    {
        Description = "Standard Authorization header using the Bearer scheme (\"Bearer {token}\")",
        In = ParameterLocation.Header,
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey
    });
});


builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.Authority = $"https://securetoken.google.com/{firebaseProjectName}";
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = false,
            ValidIssuer = $"https://securetoken.google.com/{firebaseProjectName}",
            ValidateAudience = false,
            ValidAudience = firebaseProjectName,
            ValidateLifetime = false
        };
    });


var firebaseAuthClient = new FirebaseAuthClient(new FirebaseAuthConfig
{
    ApiKey = "AIzaSyDRWNkzyTKJqw2F4Zc1WuGNyXbYgaurKTA",
    AuthDomain = $"{firebaseProjectName}.firebaseapp.com",
    Providers = new FirebaseAuthProvider[]
    {
        new EmailProvider(),
        new GoogleProvider()
    }
});

builder.Services.AddSingleton(firebaseAuthClient);


builder.Services.AddSingleton<IFirestoreShoeService>(s => new FirestoreShoeService(
    FirestoreDb.Create(firebaseProjectName)
    ));

builder.Services.AddSingleton<IFirestoreVendorService>(s => new FirestoreVendorService(
    FirestoreDb.Create(firebaseProjectName)
    ));

builder.Services.AddSingleton<IFirebaseAuthService>(s => new FirebaseAuthService(firebaseAuthClient,
    FirestoreDb.Create(firebaseProjectName)
    ));

builder.Services.AddSingleton<IFirebaseStorageService>(s => new FirebaseStorageService(StorageClient.Create()));


Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", @"C:\Users\RAUL 10 PRO\Desktop\hackitall-singleton-firebase-adminsdk-dfja2-f770a052a1.json");

builder.Services.AddSingleton(FirebaseApp.Create());


//builder.Services.AddSingleton<IFirebaseAuthService, FirebaseAuthService>();


builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();


builder.Services.AddCors(options =>
{
    options.AddPolicy("VueCorsPolicy",
        builder =>
        {
            builder.WithOrigins("http://localhost:8080")
                   .AllowAnyHeader()
                   .AllowAnyMethod();
        });
});


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}


app.UseHttpsRedirection();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.UseCors("VueCorsPolicy");

app.Run();
