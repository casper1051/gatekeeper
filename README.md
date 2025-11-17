# gatekeeper

Simple system-d based proxy service for managing private networking systems.  
It forwards any connections connecting to it to any local LAN IP using socat.  
Only Debian and Debian-based distros are supported.

---

### Install by running:

```bash
curl -fsSL https://raw.githubusercontent.com/casper1051/gatekeeper/main/install.sh | bash
```

---

### The script will overwrite the following:

- `/etc/gatekeeper/rules.conf`  
- `/usr/local/bin/gatekeeper.sh`  
- `/etc/systemd/system/gatekeeper.service`

---

### Optional: `vigatekeeper`

There is the tiny command `vigatekeeper`.  
This will be automatically installed **if the file at `/usr/local/bin/vigatekeeper` does not exist**.  

It will automatically apply any edits you make to the gatekeeper rules file.
