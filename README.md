<div align="center">

# 🧪 Bad-Pi Security Lab

### A Windows payload-analysis playground for defenders

Static-analysis samples, emulation scripts, and intentionally suspicious delivery chains for isolated security research.

> ⚠️ **Handle as malware. Do not execute these files on a personal, production, or network-connected machine.**

</div>

---

## What this lab contains

This repository is a small collection of Windows-focused samples that demonstrate techniques defenders may encounter during incident response and malware triage:

| Area | Samples | Defensive focus |
| --- | --- | --- |
| **Delivery** | `hta/`, `vbs/`, `mr_white.docx` | Suspicious document and script-based launch paths |
| **Execution** | `bat/`, `ps1/` | PowerShell, Run-dialog automation, and hidden windows |
| **Persistence** | `ps1/s2.ps1` | Per-user startup persistence |
| **Collection** | `ps1/s2.ps1` | Document discovery and archive staging |
| **Network activity** | `vbs/payload.vbs`, `bat/test_003.bat` | Outbound webhook and HTTP behavior |
| **Local AI helper** | `scripts/agent.py` | Ollama-backed command-line assistant |

The samples are intentionally mixed in quality and style so they can be used to practice identifying indicators, suspicious parent/child processes, obfuscation, persistence, and data-access patterns.

## Repository map

```text
.
├── bat/                  # Batch-based lab demonstrations
├── hta/                  # HTA delivery sample
├── ps1/                  # PowerShell stages and builder
├── scripts/              # Local analysis helper
├── vbs/                  # VBScript network/display sample
└── mr_white.docx        # Suspicious document sample
```

## Recommended workflow

Use an **offline disposable Windows VM** with no shared folders, clipboard, credentials, or personal data:

1. Preserve hashes and metadata before opening anything.
2. Read and de-obfuscate source statically.
3. Extract URLs, registry paths, file extensions, and process names as indicators.
4. Monitor behavior only in a controlled lab with simulated data.
5. Revert the VM after each experiment.

For routine review, start with the PowerShell and script files in a text editor or an isolated analysis pipeline. Treat any network endpoint and any embedded credential field as untrusted.

## Safety notes

- **Do not run the samples directly.**
- **Do not fill in credentials or point the samples at real services.**
- **Do not use real documents, email accounts, or network shares.**
- The repository includes behaviors that can create persistence, inspect user files, stage archives, display disruptive windows, and send HTTP/SMTP traffic.
- If you discovered this repository on a live system, isolate the host and investigate persistence locations, PowerShell logs, process ancestry, and outbound connections.

## Defensive investigation checklist

- Review `HKCU\Software\Microsoft\Windows\CurrentVersion\Run`.
- Search PowerShell operational logs for encoded commands and download-and-execute patterns.
- Hunt for unusual `.lnk`, `.hta`, `.vbs`, and Office-spawned child processes.
- Check temporary directories for recently created archives.
- Block or investigate unexpected webhook, SMTP, and raw-content download destinations.

## Status

🚧 **Research / educational material** — not production software and not a safe end-user utility.

<div align="center">

**Analyze responsibly. Isolate first.**

</div>
