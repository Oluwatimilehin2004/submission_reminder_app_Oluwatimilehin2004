# Submission Reminder App

Welcome to the **Submission Reminder App** your friendly digital assistant for keeping track of student submissions! This project was created as part of an assignment workflow where I explored **Bash scripting, automation, and Git branching** in a practical, hands-on way.  

## What I Built

This project contains **two main scripts** and a supporting structure to manage assignments and student submissions:

### 1️ `create_environment.sh`
- Think of this as the **architect of our app**.  
- Its job is to automatically **set up the entire project structure**, so no one has to manually create folders or files.  
- When you run this script, it creates a folder named:

submission_reminder_{YourName}
with all the necessary subdirectories and starter files, including:
app/
reminder.sh
assets/
submissions.txt
config/
config.env
modules/
functions.sh
startup.sh


- Essentially, it ensures the project is **ready to go instantly**, no tedious setup required.


### 2️ `copilot_shell_script.sh`
- This is the **user-friendly control center**.  
- It allows you to **update the assignment name** dynamically in the configuration file (`config/config.env`).  
- Once updated, it automatically runs the `startup.sh` script to **check which students have not submitted their assignments**.  
- This script is flexible enough to handle **multiple sub-apps**, so it works whether you have one or many classes/projects to track.


### 3️ Git Branching Workflow
To keep things **organized and professional**, I followed a **branching workflow**:

1. **Feature Branch (`feature/setup`)**  
   - This was my playground for rough work, experimentation, and iterative development.  
   - All initial scripts, tests, and updates were committed here.  

2. **Main Branch (`main`)**  
   - Contains the **final, polished scripts** that fulfill the assignment requirements:  
     - `create_environment.sh`  
     - `copilot_shell_script.sh`  
     - `README.md`  
   - This branch is kept clean, professional, and ready for submission.


## How It Works

1. **Set up the environment**  
   ```bash
   bash create_environment.sh
This creates the folder structure and starter files automatically.

2. **Update assignment and check submissions**
   bash copilot_shell_script.sh
- Enter a new assignment name (or let it auto-update all sub-apps).
- The script updates the configuration and runs startup.sh.
- You instantly get a refreshed view of non-submitting students.

**Key Design Choices**
- Automated Setup: No one likes creating repetitive directories; create_environment.sh does it all.
- Dynamic Assignment Updates: copilot_shell_script.sh ensures smooth updates and keeps student submission tracking current.
- Branching Discipline: Feature branch for rough work, main branch for the polished product — just like real-world software development.
- Scalable Architecture: The script can handle any number of sub-apps, future-proofing the project.

**Lessons Learned**
- Git branching is your friend — it allows experimentation without messing up the final submission.
- Bash scripting can automate repetitive tasks, saving time and reducing errors.
- Clear folder structure and config management make the app scalable and maintainable.
- Even a “simple” CLI script can feel like a real product when you think about user experience.

**Final Thoughts**
- This project was more than just an assignment — it was an exercise in thinking like a developer:
- Automate wherever possible.
- Keep your main branch clean and professional.
- Design scripts that are intuitive, human-friendly, and resilient.

I hope anyone using this project feels like they have a small digital assistant keeping their submissions on track — because that’s exactly the experience I wanted to build.

“Automation is not about replacing humans; it’s about freeing humans to do more meaningful work.”
– Me, while writing this project.

**Repo Structure (Final Main Branch)**
submission_reminder_app_Oluwatimilehin2004/
├── create_environment.sh
├── copilot_shell_script.sh
└── README.md

All other rough work, test folders, and experimental files live only in the feature branch (feature/setup), keeping the main branch clean.

This README:  
- Explains **everything you did** in a narrative, human-friendly way.  
- Includes **folder structures, workflow, scripts, and lessons learned**.  
- Uses **emojis, headings, and quotes** to make it engaging.  

