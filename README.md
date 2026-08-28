# ✈️ WanderWise - Smart Travel Date Optimizer & Itinerary Planner

[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D3.13.1-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D3.1-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/Riverpod-2.5.1-000000?style=for-the-badge&logo=riverpod&logoColor=white)](https://riverpod.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-4CAF50?style=for-the-badge)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-49%20Passed%20%7C%20100%25-brightgreen.style=for-the-badge)](#10-testler)

**WanderWise**, modern gezginler için uçuş, otel, hava durumu ve bütçe verilerini yapay zeka ve ağırlıklı skorlama algoritmalarıyla analiz ederek en ideal seyahat tarihlerini optimize eden, Clean Architecture prensipleriyle geliştirilmiş cross-platform mobil uygulamadır.

---

## 📋 İçindekiler
- [1. Proje Amacı](#1-proje-amacı)
- [2. Özellikler](#2-özellikler)
- [3. Teknolojiler](#3-teknolojiler)
- [4. Kullanılan API'ler](#4-kullanılan-apiler)
- [5. Uygulama Mimarisi](#5-uygulama-mimarisi)
- [6. Kurulum](#6-kurulum)
- [7. Environment Variables](#7-environment-variables)
- [8. Uygulama Ekran Görüntüleri](#8-uygulama-ekran-görüntüleri)
- [9. Testler](#9-testler)
- [10. Gelecek Geliştirmeler](#10-gelecek-geliştirmeler)
- [11. Lisans](#11-lisans)

---

## 🎯 1. Proje Amacı

Gezginlerin seyahat planı yaparken yaşadığı en büyük zorluk; uçuş fiyatları, otel konaklama maliyetleri ve hava durumu şartlarını aynı anda değerlendirip **en ekonomik ve konforlu seyahat tarihini bulmaktır**. 

**WanderWise**, karmaşık veri noktalarını **Normalize ve Skorlama Motorları** ile işleyerek seyahat etmek istenen tarih aralığındaki her günü analiz eder. Kullanıcının seçtiği stratejiye göre (*En Dengeli*, *En Ucuz*, *En İyi Hava*, *En Kısa Yolculuk*) 0-100 arası akıllı skorlama sunar ve en ideal seyahat penceresini önerir.

---

## ✨ 2. Özellikler

- 🧠 **Akıllı Tarih Optimizer'ı (`TravelDateOptimizerService`):**
  - **4 Farklı Strateji:** En Dengeli, En Ucuz, En İyi Hava Durumu, En Kısa Yolculuk.
  - **Ağırlıklı Skorlama Algoritması:** Uçuş fiyatı, otel fiyatı, hava konforu ve seyahat sürelerini $[0.0 - 1.0]$ aralığına normalize edip 0-100 puanlık skor üretir.
- ✈️ **Canlı Uçuş ve Otel Arama:**
  - Amadeus API entegrasyonu ile gerçek zamanlı uçuş ve konaklama tekliflerini listeleyebilme.
- 🌍 **İnteraktif Harita Entegrasyonu:**
  - Destinasyon koordinatlarını harita üzerinde görselleştirme ve konum keşfi.
- 💱 **Dinamik Para Birimi Dönüşümü:**
  - Türk Lirası (₺), Amerikan Doları ($) ve Euro (€) arasında anlık kur çevirimi.
- 🌐 **Çoklu Dil Desteği (Localization):**
  - Türkçe 🇹🇷 ve İngilizce 🇬🇧 dil seçenekleri ile canlı arayüz güncellemeleri.
- 💾 **Çevrimdışı Yerel Depolama (Hive):**
  - Son aramalar, favori destinasyonlar ve uygulama ayarlarının cihaz üzerinde güvenli kalıcılığı.
- 🌙 **Dinamik Tema Desteği:**
  - Koyu (Dark Mode), Açık (Light Mode) ve Sistem Teması entegrasyonu.
- 🛡️ **Gelişmiş Güvenlik ve Input Sanitization:**
  - Güvenli regex girdi süzme, sanitize edilmiş hata yönetimi ve HTTPS zorunluluğu.

---

## 🛠️ 3. Teknolojiler

| Katman | Teknoloji / Kütüphane | Açıklama |
| :--- | :--- | :--- |
| **Framework** | Flutter `^3.13.1` / Dart `^3.1` | Cross-platform mobil uygulama geliştirme |
| **State Management** | `flutter_riverpod ^2.5.1` | Reaktif ve sürdürülebilir durum yönetimi |
| **Ağ / HTTP** | `dio ^5.4.3+1` | Rest API istemcisi ve interceptor yönetimi |
| **Yerel Depolama** | `hive ^2.2.3` & `hive_flutter ^1.1.0` | Yüksek hızlı NoSQL anahtar-değer veritabanı |
| **Yapay Zeka** | `google_generative_ai ^0.4.0` | Google Gemini AI asistan entegrasyon altyapısı |
| **Tasarım / UI** | `google_fonts ^6.2.1`, `shimmer ^3.0.0` | Modern tipografi ve yükleme animasyonları |
| **Uluslararasılaşma** | `intl ^0.19.0` | Tarih, saat ve sayı formatlama |
| **Ortam Yönetimi** | `envied ^0.5.2` | Güvenli çevre değişkenleri okuyucusu |

---

## 🔌 4. Kullanılan API'ler

1. **Amadeus Self-Service APIs:**
   - Uçuş Arama API (*Flight Offers Search*)
   - Otel Arama ve Fiyat API (*Hotel List & Offers*)
2. **Google Gemini AI API:**
   - Akıllı seyahat önerileri ve lokasyon rehberliği asistanı.
3. **OpenStreetMap / Tile APIs:**
   - İnteraktif destinasyon konum haritalandırması.

---

## 🏗️ 5. Uygulama Mimarisi

Proje, bakımı kolay, test edilebilir ve ölçeklenebilir **Clean Architecture** prensiplerine uygun olarak tasarlanmıştır.

```text
lib/
├── core/                         # Ortak Çekirdek Yapılar
│   ├── env/                      # Çevre Değişkenleri ve Yapılandırma (Env Reader)
│   ├── network/                  # DioClient & Hata Sanitizasyonu (NetworkException)
│   ├── storage/                  # Hive Depolama Servisi (LocalStorageService)
│   ├── theme/                    # Tema (Light/Dark) ve Stil Tanımları
│   ├── utils/                    # Validasyon (SearchValidator), Formatlama & Dönüştürücüler
│   └── localization/             # Çoklu Dil ve Yerelleştirme Sağlayıcıları
└── features/                     # Özellik Modülleri (Feature-First Pattern)
    ├── home/                     # Ana Sayfa ve Popüler Destinasyonlar
    ├── planner/                  # Tarih Optimizer'ı ve Skorlama Motoru
    ├── flight/                   # Uçuş Arama, Teklif Servisleri ve Kartları
    ├── hotel/                    # Otel Arama, Teklif Servisleri ve Kartları
    ├── map/                      # İnteraktif Harita Bileşenleri
    ├── explore/                  # Keşfet Ekranı ve Rehberler
    └── profile/                  # Kullanıcı Tercihleri ve Ayarlar
```

---

## 🚀 6. Kurulum

### Ön Koşullar
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>=3.13.1`)
- [Dart SDK](https://dart.dev/get-dart) (`>=3.1.0`)
- Android Studio / VS Code (Flutter eklentileri yüklenmiş)

### Adım Adım Kurulum

1. **Depoyu klonlayın:**
   ```bash
   git clone https://github.com/kullanici-adi/travel_app.git
   cd travel_app
   ```

2. **Bağımlılıkları yükleyin:**
   ```bash
   flutter pub get
   ```

3. **Çevre Değişkenlerini Oluşturun:**
   Kök dizindeki `.env.example` dosyasını `.env` olarak kopyalayın ve API anahtarlarınızı ekleyin:
   ```bash
   cp .env.example .env
   ```

4. **Uygulamayı Çalıştırın:**
   ```bash
   flutter run
   ```

---

## 🔐 7. Environment Variables

Uygulama, hassas API anahtarlarını güvenli bir şekilde yönetmek için `.env` dosyasını kullanır. 

> ⚠️ **ÖNEMLİ:** Gerçek API key veya secret bilgilerinizi kesinlikle kod deposuna push etmeyin! `.env` dosyası `.gitignore` ile korumaya alınmıştır.

| Değişken Adı | Açıklama | Örnek Değer |
| :--- | :--- | :--- |
| `AMADEUS_CLIENT_ID` | Amadeus Developer Portalı Client ID | `your_amadeus_client_id_here` |
| `AMADEUS_CLIENT_SECRET` | Amadeus Developer Portalı Client Secret | `your_amadeus_client_secret_here` |
| `GEMINI_API_KEY` | Google AI Studio Gemini API Key | `your_gemini_api_key_here` |

Projeyi komut satırından `--dart-define` ile derlemek isterseniz:
```bash
flutter run --dart-define=AMADEUS_CLIENT_ID=xxx --dart-define=AMADEUS_CLIENT_SECRET=yyy --dart-define=GEMINI_API_KEY=zzz
```

---

## 🖼️ 8. Uygulama Ekran Görüntüleri

| Ana Sayfa & Optimizer | Tarih Seçimi & Skorlama | Otel & Uçuş Arama | Profil & Ayarlar |
| :---: | :---: | :---: | :---: |
| ![Ana Sayfa](docs/screenshots/home_screen.png) | ![Optimizer](docs/screenshots/optimizer_screen.png) | ![Arama](docs/screenshots/search_screen.png) | ![Profil](docs/screenshots/profile_screen.png) |

*(Not: Ekran görüntülerini `docs/screenshots/` klasörüne ekleyerek repository sayfanızda görsel şölen oluşturabilirsiniz.)*

---

## 🧪 9. Testler

WanderWise, yüksek kod kalitesi ve kararlılık için kapsamlı birim (Unit) ve bileşen (Widget) test paketine sahiptir.

### Testleri Çalıştırma
Projedeki tüm testleri çalıştırmak için aşağıdaki komutu kullanabilirsiniz:

```bash
flutter test
```

### Test Kapsamı (49 Passed / 0 Failed)
- 🧪 **`NetworkException` Tests:** Ağ hatalarının güvenli süzülmesi ve kullanıcı dostu mesaj dönüşümü.
- 🧪 **`LocalStorage` & Hive Tests:** Veritabanı kalıcılığı, arama geçmişi limiti ve key temizliği.
- 🧪 **`FlightOffer` & `HotelOffer` Parser Tests:** JSON modellerinin doğrulanması.
- 🧪 **`SearchValidator` Tests:** XSS, HTML enjeksiyonu ve karakter sınırı güvenlik testleri.
- 🧪 **`TravelDateOptimizer` Math Tests:** Dengeli, En Ucuz, En İyi Hava ve En Kısa Yolculuk skorlama algoritmaları.
- 🧪 **`AppSettings` & UI Widget Tests:** Tema senkronizasyonu, kart renderı ve kullanıcı etkileşimleri.

---

## 🔮 10. Gelecek Geliştirmeler

- [ ] 🗺️ **Çevrimdışı Harita Önbellekleme:** Seyahat esnasında internet olmadan harita görüntüleme.
- [ ] 👥 **Sosyal Rota Paylaşımı:** Oluşturulan seyahat planlarını PDF / QR kod olarak dışa aktarma.
- [ ] 🔔 **Fiyat Düşüş Bildirimleri:** Favori uçuş ve oteller için push notification servis entegrasyonu.
- [ ] 🧳 **Bavul Hazırlık Listesi (Smart Packing List):** Gidilecek yerin hava durumuna göre otomatik bavul listesi önerme.

---

## 📄 11. Lisans

Bu proje [MIT Lisansı](LICENSE) altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına göz atabilirsiniz.

---

<p align="center">
  Crafted with ❤️ by <b>WanderWise Team</b>
</p>
