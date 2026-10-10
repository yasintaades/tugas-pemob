using System.Data;
using Dapper;
using Npgsql;

var builder = WebApplication.CreateBuilder(args);

// Port binding agar bisa diakses dari HP Realme via IP Wi-Fi
builder.WebHost.UseUrls("http://0.0.0.0:5050");

// Konfigurasi CORS agar Flutter Web / Mobile bisa request tanpa halangan
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

var app = builder.Build();

app.UseCors("AllowAll");

IDbConnection CreateConnection() => new NpgsqlConnection(connectionString);

// Health check endpoint
app.MapGet("/", () => Results.Ok(new
{
    status = "Online",
    message = "Pemob .NET Web API is running",
    database = "pemob_db (PostgreSQL)"
}));

// ==========================================
// 1. BIODATA MAHASISWA ENDPOINTS (MENU 1)
// ==========================================

app.MapGet("/api/biodata", async () =>
{
    using var db = CreateConnection();
    var nim = "20230801033"; // Default Yasinta Desty Natalia

    var bio = await db.QueryFirstOrDefaultAsync<dynamic>(
        "SELECT * FROM biodata WHERE nim = @nim LIMIT 1", new { nim });

    if (bio == null) return Results.NotFound(new { message = "Biodata tidak ditemukan" });

    var pendidikan = await db.QueryAsync<dynamic>(
        "SELECT jenjang, nama_institusi, jurusan, periode, nilai_akhir FROM pendidikan WHERE nim = @nim ORDER BY id ASC", new { nim });

    var pekerjaan = await db.QueryAsync<dynamic>(
        "SELECT posisi, perusahaan, periode, tipe, deskripsi FROM pekerjaan WHERE nim = @nim ORDER BY id ASC", new { nim });

    var organisasi = await db.QueryAsync<dynamic>(
        "SELECT nama_organisasi, jabatan, periode, peran FROM organisasi WHERE nim = @nim ORDER BY id ASC", new { nim });

    return Results.Ok(new
    {
        nim = bio.nim,
        namaLengkap = bio.nama_lengkap,
        namaPanggilan = bio.nama_panggilan,
        tempatTanggalLahir = bio.tempat_tanggal_lahir,
        jenisKelamin = bio.jenis_kelamin,
        agama = bio.agama,
        alamat = bio.alamat,
        email = bio.email,
        noHp = bio.no_hp,
        statusMahasiswa = bio.status_mahasiswa,
        pendidikan,
        pekerjaan,
        organisasi
    });
});

app.MapPut("/api/biodata", async (UpdateBiodataRequest req) =>
{
    using var db = CreateConnection();
    var sql = @"UPDATE biodata SET 
                nama_lengkap = @NamaLengkap,
                nama_panggilan = @NamaPanggilan,
                tempat_tanggal_lahir = @TempatTanggalLahir,
                jenisKelamin = @JenisKelamin,
                agama = @Agama,
                alamat = @Alamat,
                email = @Email,
                no_hp = @NoHp
                WHERE nim = @Nim";

    var affected = await db.ExecuteAsync(sql, req);
    return affected > 0 
        ? Results.Ok(new { message = "Biodata berhasil diperbarui" })
        : Results.NotFound(new { message = "Mahasiswa tidak ditemukan" });
});

// ==========================================
// 2. NILAI MAHASISWA ENDPOINTS (MENU 2)
// ==========================================

app.MapGet("/api/nilai", async () =>
{
    using var db = CreateConnection();
    var list = await db.QueryAsync<dynamic>(
        "SELECT id, nim, nama, mata_kuliah AS mataKuliah, nilai_kehadiran AS nilaiKehadiran, nilai_tugas AS nilaiTugas, nilai_uts AS nilaiUTS, nilai_uas AS nilaiUAS, nilai_akhir AS nilaiAkhir, grade, status FROM nilai_mahasiswa ORDER BY id DESC"
    );
    return Results.Ok(list);
});

app.MapPost("/api/nilai", async (SaveNilaiRequest req) =>
{
    using var db = CreateConnection();

    // Hitung otomatis Nilai Akhir & Grade
    double akhir = (req.NilaiKehadiran * 0.10) +
                   (req.NilaiTugas * 0.20) +
                   (req.NilaiUTS * 0.30) +
                   (req.NilaiUAS * 0.40);

    string grade = akhir >= 85 ? "A" :
                   akhir >= 80 ? "A-" :
                   akhir >= 75 ? "B+" :
                   akhir >= 70 ? "B" :
                   akhir >= 65 ? "B-" :
                   akhir >= 60 ? "C+" :
                   akhir >= 55 ? "C" :
                   akhir >= 40 ? "D" : "E";

    string status = akhir >= 55 ? "LULUS" : "TIDAK LULUS";
    string id = string.IsNullOrEmpty(req.Id) ? DateTimeOffset.UtcNow.ToUnixTimeMilliseconds().ToString() : req.Id;

    var sql = @"INSERT INTO nilai_mahasiswa 
                (id, nim, nama, mata_kuliah, nilai_kehadiran, nilai_tugas, nilai_uts, nilai_uas, nilai_akhir, grade, status)
                VALUES (@id, @Nim, @Nama, @MataKuliah, @NilaiKehadiran, @NilaiTugas, @NilaiUTS, @NilaiUAS, @akhir, @grade, @status)
                ON CONFLICT (id) DO UPDATE SET 
                nama = EXCLUDED.nama, mata_kuliah = EXCLUDED.mata_kuliah, nilai_akhir = EXCLUDED.nilai_akhir, grade = EXCLUDED.grade, status = EXCLUDED.status";

    await db.ExecuteAsync(sql, new
    {
        id,
        req.Nim,
        req.Nama,
        req.MataKuliah,
        req.NilaiKehadiran,
        req.NilaiTugas,
        req.NilaiUTS,
        req.NilaiUAS,
        akhir,
        grade,
        status
    });

    return Results.Ok(new
    {
        id,
        req.Nim,
        req.Nama,
        req.MataKuliah,
        req.NilaiKehadiran,
        req.NilaiTugas,
        req.NilaiUTS,
        req.NilaiUAS,
        nilaiAkhir = akhir,
        grade,
        status
    });
});

app.MapDelete("/api/nilai/{id}", async (string id) =>
{
    using var db = CreateConnection();
    var affected = await db.ExecuteAsync("DELETE FROM nilai_mahasiswa WHERE id = @id", new { id });
    return affected > 0
        ? Results.Ok(new { message = "Nilai berhasil dihapus" })
        : Results.NotFound(new { message = "Data tidak ditemukan" });
});

// ==========================================
// 3. USER PROFILE ENDPOINTS (MENU 3)
// ==========================================

app.MapGet("/api/profile", async () =>
{
    using var db = CreateConnection();
    var nim = "20230801033";
    var profile = await db.QueryFirstOrDefaultAsync<dynamic>(
        "SELECT nim, nama, email, program_studi AS programStudi, fakultas, universitas, semester, ipk, sks_lulus AS sksLulus, avatar_url AS avatarUrl FROM user_profile WHERE nim = @nim LIMIT 1",
        new { nim }
    );
    return profile != null ? Results.Ok(profile) : Results.NotFound();
});

app.MapPut("/api/profile", async (UpdateProfileRequest req) =>
{
    using var db = CreateConnection();
    var sql = @"UPDATE user_profile SET 
                nama = @Nama,
                email = @Email,
                program_studi = @ProgramStudi,
                fakultas = @Fakultas,
                universitas = @Universitas,
                semester = @Semester
                WHERE nim = @Nim";

    var affected = await db.ExecuteAsync(sql, req);
    return affected > 0
        ? Results.Ok(new { message = "Profil berhasil diperbarui" })
        : Results.NotFound();
});

app.Run();

// ==========================================
// DTO RECORD MODELS
// ==========================================

public record UpdateBiodataRequest(
    string Nim,
    string NamaLengkap,
    string NamaPanggilan,
    string TempatTanggalLahir,
    string JenisKelamin,
    string Agama,
    string Alamat,
    string Email,
    string NoHp
);

public record SaveNilaiRequest(
    string? Id,
    string Nim,
    string Nama,
    string MataKuliah,
    double NilaiKehadiran,
    double NilaiTugas,
    double NilaiUTS,
    double NilaiUAS
);

public record UpdateProfileRequest(
    string Nim,
    string Nama,
    string Email,
    string ProgramStudi,
    string Fakultas,
    string Universitas,
    string Semester
);
