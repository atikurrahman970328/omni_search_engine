# OmniSearch Engine for Android

**OmniSearch Engine** হলো একটি প্রফেশনাল, স্কেলেবল এবং হাই-পারফর্ম্যান্স অল-ইন-ওয়ান লোকাল সার্চ ইঞ্জিন অ্যাপ্লিকেশন। এটি অ্যান্ড্রয়েডের সাধারণ ফাইল ম্যানেজারগুলোর সীমার বাইরে গিয়ে সিস্টেমের প্রতিটি কোণ, হিডেন ক্যাশ, মেটাডেটা, শিজুকু অ্যাক্টিভিটি এবং নেটওয়ার্ক কানেকশন ইনডেক্স ও সার্চ করতে সক্ষম।

---

## 🚀 মূল ফিচারসমূহ (15 Key Features)

1. **Deep File & Directory Indexer:** ডট-ফোল্ডার, ক্যাশ এবং `.nomedia` ফোল্ডারের ফাইল স্ক্যান।
2. **Media Metadata Engine:** FFmpeg দিয়ে ভিডিও/অডিও ফাইলের ডিউরেশন, বিটরেট ও কোডেক পার্সিং।
3. **Hidden Settings & Activity Launcher:** Shizuku/ADB দিয়ে সিস্টেমের গোপন অ্যাক্টিভিটি লঞ্চ।
4. **Shizuku Command Runner:** ইন্টারঅ্যাক্টিভ কাস্টম `adb shell` কম্যান্ড প্রসেসিং।
5. **App Permission Auditor:** অ্যাপের বিপজ্জনক পারমিশনসমূহ স্ক্যান ও ফিল্টারিং।
6. **In-File Document Content Parser:** PDF ও TXT ফাইলের ভেতরের লেখা দিয়ে সার্চ।
7. **Nightly Auto-Indexer:** অটোমেটিক ব্যাকগ্রাউন্ড শিডিউল ও ব্যাকগ্রাউন্ড সিঙ্ক।
8. **GitHub Actions CI/CD:** গিটহাব পুশেই ক্লাউডে রিলিজ APK ফাইল বিল্ড।
9. **OCR Image Text Indexer:** ইমেজের ভেতরে থাকা টেক্সট বা স্ক্রিনশট চিনে ছবি খোঁজা।
10. **Duplicate & Heavy File Cleanup:** ডুপ্লিকেট ফাইল ও ভারী মেমোরি ফিল্টার।
11. **APK Backup & Exporter:** ইনস্টল থাকা অ্যাপের APK ব্যাকআপ সংরক্ষণ।
12. **EXIF Metadata Location Search:** ক্যামেরা ও জিপিএস মেটাডেটা দিয়ে ছবি সার্চ।
13. **App Network & IP Logger:** ব্যাকগ্রাউন্ড অ্যাপস কোন আইপিতে ডাটা পাঠাচ্ছে তা ট্রেস।
14. **Cross-Platform Local Web UI:** ব্রাউজার থেকে মোবাইল ফাইল সিস্টেম সার্চ করার সুবিধা।
15. **Block-Level Forensic Recovery:** মুছে ফেলা ফাইলের রিকভারি সার্চ।

---

## 🏛️ আর্কিটেকচারাল ডিজাইন

* **Pattern:** Clean Architecture (MVVM + Feature-First Modular Driven)
* **Framework:** Flutter / Dart
* **Database:** SQLite with FTS5 (Full-Text Search Trigram Indexing)
* **Native Bridge:** MethodChannel + Kotlin + Shizuku API
* **State Management:** Flutter Riverpod

---

## 🛠️ টার্মাক্স ও গিটহাব অটোমেশন দিয়ে বিল্ড প্রসেস

১. গিটহাব রিপোজিটরিতে কোড পুশ করুন:
   ```bash
   git add .
   git commit -m "Updated OmniSearch core architecture"
   git push origin main