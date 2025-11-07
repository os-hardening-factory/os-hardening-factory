#!/usr/bin/env python3
import json, os, subprocess

LYNIS_REPORT = "reports/lynis-ubuntu.txt"
TRIVY_REPORT = "reports/trivy-ubuntu.json"

def read_lynis_score():
    try:
        with open(LYNIS_REPORT) as f:
            for line in f:
                if "Hardening index" in line:
                    return int(line.split()[-1])
    except Exception:
        pass
    return 0

def read_cve_counts():
    try:
        with open(TRIVY_REPORT) as f:
            data = json.load(f)
        crit = sum(1 for r in data.get("Results", []) for v in (r.get("Vulnerabilities") or []) if v["Severity"] == "CRITICAL")
        high = sum(1 for r in data.get("Results", []) for v in (r.get("Vulnerabilities") or []) if v["Severity"] == "HIGH")
        return crit, high
    except Exception:
        return 0, 0

def remediate_if_needed():
    score = read_lynis_score()
    crit, high = read_cve_counts()
    print(f"🧩 Lynis score={score}, Critical CVEs={crit}, High CVEs={high}")
    if score < 80 or crit > 0 or high > 5:
        print("⚠️ Compliance thresholds not met. Running remediation...")
        subprocess.run(
            ["ansible-playbook", "packer/ubuntu/ansible/playbook.yml", "-e", "remediation_mode=true"],
            check=False,
        )
        print("✅ Remediation applied. You may trigger re-validation manually.")
    else:
        print("✅ System is compliant. No remediation needed.")

if __name__ == "__main__":
    remediate_if_needed()
