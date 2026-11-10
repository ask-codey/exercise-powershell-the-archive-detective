# Exercise: The Archive Detective

Exercise code for the lesson **Exercise: The Archive Detective** in PowerShell in Depth on [ask-codey.com](https://www.ask-codey.com).

The town archive's brass telescope has gone missing from the observatory room. The archivist has two weeks of door logs, a staff list, a basement full of lockers and a storage room full of boxes, and no time to read any of them. You'll solve the case with PowerShell's searches, and a Pester check tells you which answers are right.

## What's here

- `notice.txt`: the archivist's note about what happened.
- `logs/`: the door log for every day from November 1 to 14, one file a day. Each line is a time, a door, a badge number and what happened.
- `staff.txt`: who carries which badge.
- `lockers/`: every staff member's locker, in folders by floor and row.
- `storage/`: the storage room's boxes, on four shelves.
- `answers.txt`: one line for each question, waiting for your answer. For you to finish.
- `Check.Tests.ps1`: the check. You don't need to change it.

## What to do

Open PowerShell 7 and go into this folder with `Set-Location`. Then use the commands from the *Searching* chapter: `Select-String`, `Get-ChildItem -Recurse` with `-Filter` and `Where-Object`, and a regular expression. Don't read the logs from top to bottom: search them.

Write each answer after its number in `answers.txt`, on the same line, for example `1) 2026-11-01.log`, and save the file.

1. The observatory was opened in the small hours, between midnight and 5:59 AM. Search every log for lines in the small hours with the pattern `'^0[0-5]:'` (a time that starts with 00 to 05). One of them is at the observatory. Which log file is it in?
2. Which badge number opened the observatory that night?
3. Whose badge is it? Write the name from `staff.txt`.
4. How many lines, in all the logs together, mention that badge number?
5. Find that person's locker with `Get-ChildItem -Recurse`. What's the locker folder's path from this folder? It starts with `lockers\`.
6. Read what's in the locker. Then find the one file under `storage` that's bigger than 50 KB. What's its name?

## Check your work

The check needs Pester 5 or newer. Install it once, if you haven't already:

```powershell
Install-PSResource Pester
```

Then, from this folder:

```powershell
Invoke-Pester
```

At first every test fails: that is expected. Each answer you get right turns its test green. A failing test's message says which question it is and what to try.

If PowerShell says the check *cannot be loaded because running scripts is disabled* or *is not digitally signed*, the folder came from a download that Windows marked as from the internet. Unblock its files once with `Get-ChildItem -Recurse | Unblock-File`, from this folder, and run `Invoke-Pester` again. *Why a Script Won't Run: The Execution Policy*, in Module 5, explains what that does.

## Tips

- Put patterns in single quotes: `'^0[0-5]:'`. In double quotes, PowerShell would try to read `$` and other signs itself.
- `Select-String` ignores capital letters, and so does `-Filter` on Windows: `'*felix*'` and `'*Felix*'` find the same names.
- `| Measure-Object` counts whatever comes through the pipe. Its `Count` is the number you want.
- `100KB` means a hundred kilobytes, so `Where-Object Length -gt 50KB` keeps files bigger than 50 kilobytes.
- On a Mac or Linux, write paths with `/` (`logs/*`). The check accepts answers written with `/` or `\`.

## Hand it in

When it works, push your solution to a public repo of your own on GitHub, then paste that repo's address into **Submit your exercise** on the lesson page at [ask-codey.com](https://www.ask-codey.com). That's what completes the lesson. The lesson page shows the Git commands, step by step.
