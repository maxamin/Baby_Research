# Baby_Research (For educational purposes only)
![GitHub Logo](https://github.com/maxamin/Baby_Research/blob/main/resources/logo.jpg?raw=true)

Attempt to reverse 0xcheats.net MTA cheat 
Multi Theft Auto (MTA) is a modification for the popular video game "Grand Theft Auto: San Andreas." It is designed to enhance the multiplayer aspect of the game by providing players with the ability to connect to servers and engage in various multiplayer game modes. MTA expands upon the original single-player experience of Grand Theft Auto: San Andreas by introducing a dynamic and customizable multiplayer environment.

Key features of Multi Theft Auto include:

Multiplayer Functionality: MTA allows players to connect to servers where they can interact with other players in the vast open-world environment of San Andreas.
Custom Game Modes: Server administrators have the flexibility to create and customize game modes, ranging from traditional deathmatch scenarios to more complex role-playing experiences. This versatility has led to the development of a wide variety of player-created game modes.
Scripting Support: One of the distinguishing features of MTA is its scripting support, allowing server administrators to create custom scripts and modifications for their servers. This capability enables the development of unique gameplay mechanics and features.
Community Content: The MTA community contributes significantly to the platform by creating and sharing custom maps, scripts, and other content. This collaborative effort has resulted in a diverse range of multiplayer experiences.
Stability and Performance: MTA strives to maintain stability and performance, providing a seamless multiplayer experience for players. This is crucial for large-scale servers and various game modes.
#0XCHEATS
0xCheats - is a team of experienced guys developing software for games such as GTA Online, RDR Online, RAGEMP and other games
and they describe their products as it follows:
Software
Our team develops software with all their knowledge and skills
Optimization
Our product does not affect system performance during operation
Development process
You can take an active part in the development by offering your ideas and other things
Responsive support
Our support team will help you solve any problems that arise
Software security
We take care of the condition of the product to prevent any detections
Price and quality
For the provided functionality, the price is lower than that of competitors
I initiated this research with the aim of gaining a deeper understanding of the techniques and methods employed by cheat creators. The initial phase involved the installation of both GTA SA and MTA.
I requested a friend to furnish me with the 0xcheats cheat and respond to a few inquiries.
Q:What do you think is the first hard thing that will encounter me.
A: FairplayKD.sys driver which is an anti cheating driver made by Rockstar
Q:what else:
A: i think netc.dll is the library that contains the kicking functionality
Q:how can i deactivate Fairplay
A:when MTA starts a copy of FairplayKD.sys dropps into the filesystem and it get loaded by memory you can stop this service from process hacker then proceed to delete service after you need to open the related registry key
Starting with this step i added two other mechanisms the first which the intended cheat will execute cmd.exe /c sc stop FairPlayKD>null 2>null
restrict the making of FairPlayKD.sys on the subdirectory tree under C:\ProgramData\MTA San Andreas All using ACL
restrict the making of FairPlayKD.sys on the subdirectory tree under C:\ProgramData\MTA San Andreas All using GPO
writing a script that uses FairplayKD.sys hash to delete everything that looks similar under C:\ProgramData\MTA San Andreas All
Using applocker:
If the process creating the file has admin privileges, it can potentially override file system permissions. In such cases, you might need to consider additional measures. One approach is to use AppLocker, a Windows feature that allows you to control which applications are allowed to run on your system.

Here's a general guide on using AppLocker to deny the execution of a specific file:

    Open Local Security Policy:
        Press Win + R to open the Run dialog.
        Type secpol.msc and press Enter.

    Navigate to AppLocker:
        In the Local Security Policy window, navigate to Application Control Policies > AppLocker.

    Configure Executable Rules:
        Right-click on Executable Rules and select Create Default Rules.
        This will create rules that allow all executables in Windows and Program Files folders, while denying executables in user folders.

    Create a Deny Rule:
        Right-click on Executable Rules again and choose Create New Rule.
        In the Rule Wizard, select Deny for the action.
        Choose the conditions for your rule. For example, you might want to specify a path condition for the folder where the unwanted file is being created.

    Specify the File:
        In the Exceptions step of the wizard, you can specify exceptions if needed.
        Provide a description for your rule, and click Create.

    Enforce AppLocker:
        After creating the rule, right-click on AppLocker in the left pane and select Enforce Rules.
now to the next step:
Realizing that im not getting payed to do all of this shit:
Every dll in the MTA directory contains anti debugging mechanisms often imported from Windows internal dlls i can site some like:
    IsDebuggerPresent:
        Used to check if the current process is being debugged.

    DebugActiveProcessStop:
        Used to stop debugging a process.

    OutputDebugString:
        Used to send a string to the debugger.

    QueryPerformanceCounter and QueryPerformanceFrequency:
        Used to measure time intervals with high precision, which can be used to detect time discrepancies caused by debugging.

    GetCurrentProcessId, GetProcessId, GetCurrentThreadId, GetThreadTimes:
        Used to retrieve information about the current process and thread, which can be used to detect anomalies introduced by debugging.

    CreateToolhelp32Snapshot, Thread32First, Thread32Next:
        Used for enumerating processes and threads, potentially to detect the presence of debugging tools.

    Sleep:
        Used to introduce delays, making it more difficult for a debugger to step through the code.

    RaiseException:
        Used to trigger an exception, which can be intercepted by a debugger.

    GetTickCount:
        Used to measure system uptime, which can be compared with the expected time progression to detect anomalies caused by debugging.

    TerminateProcess, ExitProcess, ExitThread:
        Used to terminate a process or thread abruptly, possibly to thwart debugging attempts.

    SetUnhandledExceptionFilter:
        Used to set a custom unhandled exception filter, which can be used to detect or hinder exception handling by a debugger.
And a cheater need to patch all dlls (starting with the loader which is opensourced) under %MTA_DIRECTORY% which is hard and requires tempering the gta_sa_diff.dat that contains all the hashes for dlls and before it get loaded this function checks it After MTA.EXE initializes DoWinMain()
which calls 
InitNetRev()
GetNetRev()
GetNetRef()
checkService()
bool FileGenerator::IsPatchBase(const fs::path& filePath)
{
    std::error_code ec{};
    FileHash        hash{};

    if (GetFileHash(filePath, hash, ec) && hash == HASH_PATCH_BASE)
        return true;

    if (IsErrorCodeLoggable(ec))
    {
        const uintmax_t fileSize = GetFileSize(filePath);
        AddReportLog(5053, SString("IsPatchBase: Incorrect file '%ls' (err: %d, size: %ju, hash: %s)", filePath.wstring().c_str(), ec.value(), fileSize,
                                   GetFileHashString(hash).c_str()));
    }

    return false;
}
IsPatchBase Gets called and after Gta san all gets called which is highly multithreaded and calls netc.dll to kick you off after revising netc.dll i found that  it exports
CheckCompatibility
CheckService
GetLibMtaVersion
GetNetRel(Usual sus)
GetNetRev(Usual sus)
InitNetinterface
InitNetRev
NtTerminateProcess
ReleaseNetinterface
_RoGetActivationFactory
GetMTADirectory
GetGTADirectory
WaitForObject(Hostile against debugging,and it Getsanobj)
and its encrypted and can be decrypted using a function in the mta executable
After i saw that:
client.dll
deathmatch.dll
libcef.dll
contains strings related to the kick procedure
#Also what works#:
APIMON
APILOGGER
WINDBG (Kernel debbugging using a vm) to interact with loaded device drivers:
Refer to :https://voidsec.com/windows-drivers-reverse-engineering-methodology/#devices-symlinks
HTTPDebugger to inspect auth requests and responses
IDA pro static analysis
ProcMon
Entropy analysis using binwalk
#Experimental ahimia section unpacker using artifacts from ghidra#
#Ghidra output to the single in memory unpacking function goes like this:#
int entry(byte *source, undefined4 unused, byte *destination) {
    // Renamed variables for clarity
    byte sourceByte;
    byte carryFlag;
    uint carrySum;
    int loopCounter;
    
    // Function call with a more descriptive name
    performInitialization();

    // Initial values
    carrySum = 0x80;
    byte *destinationPointer = destination;

    do {
        // Copy source byte to destination
        sourceByte = *source;
        source++;

        *destinationPointer = sourceByte;
        destinationPointer++;

        // Bitwise operations with carry
        loopCounter = 2;
        carryFlag = CARRY1(carrySum, carrySum);
        carrySum = carrySum * '\x02';

        // Loop until carryFlag is true
        while (!carryFlag) {
            sourceByte = *source;
            source++;

            carryFlag = CARRY1(sourceByte, sourceByte) || CARRY1(sourceByte * '\x02', carryFlag);
            carrySum = sourceByte * '\x02' + carryFlag;
        }

    } while (!carryFlag);

    // Additional conditional block for carryFlag
    if (carryFlag) {
        performConditionalCopying(&source, &destinationPointer, &carrySum);
    } else {
        // Logic for the else case
        int counter = 1;

        // Loop with CARRY1 condition
        do {
            carryFlag = CARRY1(carrySum, carrySum);
            carrySum = carrySum * '\x02';

            if (carrySum == 0) {
                sourceByte = *source;
                source++;

                carryFlag = CARRY1(sourceByte, sourceByte) || CARRY1(sourceByte * '\x02', carryFlag);
                carrySum = sourceByte * '\x02' + carryFlag;
            }

            counter = counter * 2 + carryFlag;

            // More loop logic...
            
        } while (carryFlag);

        // Additional conditional block based on counter value
        if (counter != 0) {
            performConditionalOperations(&source, &destinationPointer, &carrySum);
        } else {
            // Additional logic...
        }
    }

    return (int)destinationPointer - (int)destination;

#Binance_ID:271854090#
#Long_Live_Palestine 🇵🇸#
![Merry_christmas]("https://github.com/maxamin/Baby_Research/blob/main/resources/human_christmas.jpg?raw=true")



