# 🏆 SportFolio 

An elegant iOS application built using **Swift** that allows users to explore sports, leagues, events, and teams with a modern and responsive UI.

---

# 📱 Project Overview

The Sports App helps users:

✅ Browse different sports  
✅ Explore leagues for each sport  
✅ View upcoming & latest events  
✅ Check teams details  
✅ Check player details  
✅ Save favorite leagues locally using CoreData  
✅ Enjoy smooth and modern user experience

---

# ✨ Features

## 🏠 Main Tabs

### ⚽ Sports Tab
- Display all sports using `UICollectionView`
- Two items per row with clean spacing
- Each sport contains:
  - 🖼 Sport Image
  - 🏷 Sport Name
- Navigate to leagues screen on selection

---

### ❤️ Favorites Tab
- Save favorite leagues using `CoreData`
- Similar UI to leagues screen
- Offline/Online internet handling
- Alert shown when internet is unavailable

---

# 🏆 Leagues Screen

### 📋 Features
- Built using `UITableViewController`
- Each row contains:
  - 🛡 League Badge
  - 🏷 League Name
- Circular league image
- Navigate to League Details screen

---

# 📅 League Details Screen

The screen is divided into 3 sections:

---

## ⏳ Upcoming Events
Horizontal CollectionView containing:
- 🏷 Event Name
- 📅 Event Date
- ⏰ Event Time
- 🖼 Teams Images

---

## 🔥 Latest Events
Vertical CollectionView containing:
- ⚔️ Home Team vs Away Team
- 🎯 Match Score
- 📅 Match Date
- ⏰ Match Time
- 🖼 Teams Images

---

## 👥 Teams Section and Players
Horizontal CollectionView displaying:
- ⚽ Circular Team and Players

### 👉 On Team Click
Navigate to Team Details screen.
### 👉 On Player Click
Navigate to Player Details screen.

---

# 👕 Team Details Screen

Displays:
- 🖼 Team Logo
- 🏷 Team Name
- 📝 PLayers 


---

# 🧑‍💼 Player Details Screen

Displays:

* 🖼️ Player Photo
* 🏷️ Player Name
* 📋 Player Information
* 📊 Season Statistics
* 🏆 Tournaments


---

# 🛠 Technologies Used

| Technology | Usage |
|------------|------|
| 🍎 Swift | App Development |
| 📱 UIKit | UI Components |
| 🌐 Alamofire | Networking |
| 🖼 SDWebImage | Image Loading |
| 💾 CoreData | Local Storage |
| 🧪 XCTest | Unit Testing |

---

# 🧠 Design Patterns

The project follows:

✅ MVP Architecture   

---

# 🧪 Unit Testing

Implemented unit tests for:

- ✅ Network Services
- ✅ Mock Nwetwork Services


---

# 🌐 API Used

Sports data fetched from:

🔗 https://allsportsapi.com/

---

# 🎨 Extra Features
🎬 Splash Screen <br> 
✨ Onboarding Screens  
🌙 Dark Mode Support  
🌍 Localization  
📱 Responsive Design  
💫 Smooth Animations  
🦴 Skeleton Loading

---

# 👨‍💻 Team Members

- Shahd Ashraf
- Amr Abdalrehem

