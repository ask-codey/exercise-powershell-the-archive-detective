# Checks your case: the six answers in answers.txt.
# Run it from this folder with: Invoke-Pester
# You don't need to change this file. The right answers are kept as fingerprints (SHA-256 hashes), not as text,
# so reading this file doesn't solve the case for you.

BeforeAll {
    $script:answers = @{}
    foreach ($line in Get-Content (Join-Path $PSScriptRoot 'answers.txt')) {
        if ($line -match '^\s*(\d+)\)\s*(.*)$') {
            $script:answers[[int]$Matches[1]] = $Matches[2].Trim().Trim("'", '"').Trim()
        }
    }

    # Small differences in how an answer is written don't count: capital letters, extra spaces, / or \ in a path,
    # a .\ at the start or a \ at the end.
    function ConvertTo-AnswerText([string] $text, [string] $kind) {
        $t = ($text.ToLowerInvariant() -replace '\s+', ' ').Trim()
        switch ($kind) {
            'log' { $t = ($t -replace '/', '\') -replace '^.*\\', '' -replace '\.log$', '' }
            'badge' { $t = $t -replace '^badge\s*=?\s*', '' }
            'path' {
                $t = ($t -replace '/', '\').TrimEnd('\')
                if ($t -match '(^|\\)(lockers\\.*)$') { $t = $Matches[2] }
            }
            'file' { $t = ($t -replace '/', '\') -replace '^.*\\', '' -replace '\.txt$', '' }
        }
        $t
    }

    function Get-Fingerprint([string] $text) {
        $bytes = [Text.Encoding]::UTF8.GetBytes($text)
        (Get-FileHash -InputStream ([IO.MemoryStream]::new($bytes)) -Algorithm SHA256).Hash.ToLowerInvariant()
    }

    function Test-Answer([int] $number, [string] $kind, [string] $fingerprint) {
        (Get-Fingerprint (ConvertTo-AnswerText $answers[$number] $kind)) -eq $fingerprint
    }
}

Describe 'Exercise: The Archive Detective' {

    It '1) the log with a visit to the observatory in the small hours' {
        $answers[1] | Should -Not -BeNullOrEmpty -Because 'question 1 has no answer yet. Search every log with Select-String ''^0[0-5]:'' logs\*'
        Test-Answer 1 'log' 'd66834b1e2633b31445f067d3c463d9b29e4990cf25a07f695578ef8d99b21d3' | Should -BeTrue -Because 'the answer is the name of the log file whose small-hours line says door=observatory, such as 2026-11-01.log'
    }

    It '2) the badge that opened the observatory' {
        $answers[2] | Should -Not -BeNullOrEmpty -Because 'question 2 has no answer yet. Read the badge= part of that observatory line'
        Test-Answer 2 'badge' 'b95ca3eac805e91f90741811917f3bb7fc2135586e0e4f2e10d66d432d0547d5' | Should -BeTrue -Because 'the answer is the number after badge= on the observatory line in the small hours, such as 1234'
    }

    It '3) whose badge it is' {
        $answers[3] | Should -Not -BeNullOrEmpty -Because 'question 3 has no answer yet. Search staff.txt for the badge number with Select-String'
        Test-Answer 3 'name' '16f76c5dc86ebfaed8109a5fdc48e1968974771859f3a8475170b103045605b9' | Should -BeTrue -Because 'the answer is the first and last name on that badge''s line in staff.txt'
    }

    It '4) how many log lines mention that badge' {
        $answers[4] | Should -Not -BeNullOrEmpty -Because 'question 4 has no answer yet. Search all the logs for the badge number, then count the results with Measure-Object'
        Test-Answer 4 'number' '6b51d431df5d7f141cbececcf79edf3dd861c3b4069f0b11661a3eefacbba918' | Should -BeTrue -Because 'the answer is the Count that Measure-Object shows for Select-String <badge> logs\*, a whole number'
    }

    It '5) where that person''s locker is' {
        $answers[5] | Should -Not -BeNullOrEmpty -Because 'question 5 has no answer yet. Search lockers with Get-ChildItem -Recurse -Filter and part of the name'
        Test-Answer 5 'path' 'eb6d22667701a9496113fc47db6062d5b01b0f459709d2512f825609e0a1baff' | Should -BeTrue -Because 'the answer is the locker folder''s path from this folder, starting with lockers\, such as lockers\upstairs\row-a\some-name'
    }

    It '6) the one box in storage over 50 KB' {
        $answers[6] | Should -Not -BeNullOrEmpty -Because 'question 6 has no answer yet. List storage with Get-ChildItem -Recurse -File, and keep the files over 50KB with Where-Object'
        Test-Answer 6 'file' '2f1a247f9af02a1c6ec56e769093fed57ad879be283b5f2aa5fd4cddd1331f72' | Should -BeTrue -Because 'the answer is the name of the only file under storage whose Length is greater than 50KB, such as box-01.txt'
    }
}
