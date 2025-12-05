# Bidaya

> **Bidaya** — application éducative ludique pour les enfants (6–12 ans)
> Mascotte / guide : **Arnob** (le lapin)

---

## 🚀 Présentation

**Bidaya** (بداية — «début» en arabe) est une application mobile éducative destinée aux enfants de 6 à 12 ans.
Elle combine exercices, quiz, mini-jeux et un chatbot interactif (Arnob) pour créer une relation positive à l’apprentissage et encourager la pratique quotidienne.

---

## 🎯 Objectifs

* Créer une relation positive à l’apprentissage via le personnage **Arnob**.
* Encourager l’enfant à découvrir plusieurs domaines : mathématiques, sciences, géographie, animaux…
* Offrir un apprentissage interactif et ludique avec feed-back immédiat et messages motivants.

---

## 🧩 Fonctionnalités principales

* Création de compte simple (Google ou email/mot de passe) : nom, âge (3–12), avatar (image / caméra / galerie).
* Chatbot **Arnob** : langage simple, messages «cute», emojis, réponses filtrées et adaptées aux enfants.
* Modules éducatifs : quiz & exercices (maths, sciences — corps humain, géographie, animaux).
* Mini-jeux : puzzles, memory, compléter lettres, dessin de lettres, mini-jeux mathématiques.
* Notifications locales quotidiennes (rappels de jeu/apprentissage).
* UI/UX adaptée aux enfants : icônes grandes, navigation par images, polices arrondies (ex. Poppins / Nunito), forte lisibilité.
* Feedback immédiat : sons, animations, étoiles, animations d’Arnob.
* Suivi des performances (score, historique simple).

---

## 🛠️ Stack technique

* **Frontend / Mobile** : Flutter (Dart)
* **Backend / BAA (BaaS)** : Firebase (Authentication, Firestore, Storage, Cloud Messaging)
* **IA / Chatbot** : API Google Gemini (ex. `gemini-2.0-flash`) — utiliser un modèle avec un *system prompt* conçu pour enfants
* **Design** : Maquettes Figma (animations simples)
* Tests unitaires et tests fonctionnels avec les outils Flutter (unit & widget tests)

---

## 🔒 Sécurité & confidentialité

* Protection des données des enfants (minimiser données stockées, stocker le minimum requis).
* Authentification sécurisée (OAuth pour Google + email/mot de passe hashed).
* Règles Firestore strictes (lecture/écriture autorisées seulement pour utilisateurs identifiés / structure limitée).
* Chatbot filtré : toutes les réponses passent par un système de modération/filtrage et un *system prompt* restrictif — langage simple, positif, éducatif, pas de sujets sensibles.
* Respect légal local (si ciblage d’enfants — conformité aux lois applicables sur protection des mineurs).

---

## ⚙️ Préparation (exigences)

* Flutter SDK (version stable recommandée)
* Java / Android SDK / Android Studio (pour build apk)
* Compte Firebase (projet configuré)
* Clé API pour Google Gemini (ou autre fournisseur IA)
* Variables d’environnement (exemples ci-dessous)

### Exemple `.env` (ne pas commiter)

```
FIREBASE_API_KEY=xxxx
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_APP_ID=1:xxxx:android:xxxx
GEMINI_API_KEY=sk-xxxx
GOOGLE_SERVICES_JSON=path/to/google-services.json
```

---

## ▶️ Installation & exécution locale

1. Clone le repo :

```bash
git clone https://github.com/<votre-utilisateur>/bidaya.git
cd bidaya
```

2. Installer les dépendances Flutter :

```bash
flutter pub get
```

3. Configurer Firebase :

* Ajouter `google-services.json` (Android) dans `android/app/`
* Initialiser Firebase dans le projet (voir `lib/main.dart`)
* Activer Authentication (Google + Email/Password), Firestore, Cloud Messaging si notifications

4. Configurer la clé Gemini (ou autre) dans vos variables d’environnement ou via un service sécurisé (Cloud Functions / backend)

5. Lancer l’app en debug :

```bash
flutter run
```

## ✅ Tests & validation

* **Tests unitaires** : pour logique des quiz, validation de score.
* **Tests widget** : interactions UI critiques (login, chatbot, jeu).
* **Tests fonctionnels** : parcours complet (creation compte → jouer → sauvegarde score).
* **Tests utilisateurs** : observation d’enfants (6–12 ans) pour UX, clarifier l’âge cible et la compréhension.
* Validation par l’équipe après chaque module et correction des bugs itérative.

---

## 📁 Structure recommandée du repo

```
/lib
  /screens
  /widgets
  /services  # firebase, chatbot, storage
  /models
  /utils
/assets
  /images
  /sounds
test/
android/
ios/
README.md
```

---

## 🧠 Exemple de *system prompt* (chatbot) — à adapter et sécuriser

> **System Prompt (exemple)**
> "Tu es Arnob, un petit lapin sympathique et rassurant qui aide les enfants de 6 à 12 ans à apprendre. Utilise un langage simple, des phrases courtes, des emojis gentils. Ne pose jamais de questions personnelles (adresse, école, numéro), ne traite pas de sujets pour adultes, et ne fournis pas de conseils médicaux ou juridiques. Si l'enfant demande quelque chose d'inapproprié, réponds poliment que tu ne peux pas aider et propose une activité éducative à la place."

> **Note** : toutes les requêtes utilisateur doivent être filtrées avant d’être envoyées au modèle IA et toutes les réponses générées doivent suivre des règles de modération.

---

## 🧭 Roadmap (extraits)

* v0.1 — MVP : Auth, profil, quiz maths de base, mini-jeu puzzle, chatbot de base.
* v0.2 — Ajout : modules sciences, géographie, animations d’Arnob, notifications programmées.
* v1.0 — Version stable : sauvegarde progression, réglages parentaux, déploiement stores.

---

## 📌 Contribution

1. ork → créez une branche `feature/ma-fonctionnalite` → PR vers `develop`.
2. Respectez le style Dart/Flutter (formatter).
3. Ajoutez tests pour les nouvelles fonctionnalités.
4. Ne commitez **jamais** de clés API ou fichiers sensibles (`google-services.json` ok si safe, mais pas les clés).

---

## 📞 Contact / Auteurs

* **Équipe Bidaya** :
Taleb mouna ,mounataleb199@gmail.com ,(https://github.com/MounaTaleb) 
Abri nahla ,nahlaabri2@gmail.com , (https://github.com/nahla-898) 
Abichou tasnim,abichoutasnim7@gmail.com,(http://github.com/tasnim-ab)

---

## 🧾 Annexes / Remarques

* **Design** : maquettes sur Figma (https://www.figma.com/design/rxWWife4DoRlLoq1iJ706q/Bidya?node-id=0-1&t=hp2DKexejRK8GLKC-1).
* **Charte graphique** : logo ![WhatsApp Image 2025-11-08 à 20 17 59_7992d092](https://github.com/user-attachments/assets/939dc246-35fc-47e1-b3b2-7edbb266bd18)
 palette couleurs <img width="679" height="482" alt="Capture d&#39;écran 2025-12-04 141217" src="https://github.com/user-attachments/assets/c82a8fe1-054b-476d-bd0d-9acc6135f3de" />
.
* **Hébergement APK** : héberger l’APK dans la section Releases GitHub si nécessaire (https://github.com/tasnim-ab/bideya/releases/download/v1.0/app-release.apk).

