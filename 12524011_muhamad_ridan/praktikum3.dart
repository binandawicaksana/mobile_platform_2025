def validasi_input(tanggal, bulan, tahun):
    # Cek apakah semua input berupa angka
    if not (tanggal.isdigit() and bulan.isdigit() and tahun.isdigit()):
        return "Hanya menerima format Angka"

    # Ubah ke integer
    tanggal = int(tanggal)
    bulan = int(bulan)
    tahun = int(tahun)

    # Validasi tanggal
    if not (1 <= tanggal <= 31):
        return "Anda Salah Memasukan Tanggal"

    # Validasi bulan
    if not (1 <= bulan <= 12):
        return "Anda Salah Memasukan Bulan"

    # Validasi tahun
    if not (1000 <= tahun <= 2999):
        return "Anda Salah Memasukan Tahun"

    # Jika semua valid
    return f"{tanggal}-{bulan}-{tahun}"


# Program utama
tgl = input("Masukkan tanggal: ")
bln = input("Masukkan bulan: ")
thn = input("Masukkan tahun: ")

hasil = validasi_input(tgl, bln, thn)
print(hasil)
