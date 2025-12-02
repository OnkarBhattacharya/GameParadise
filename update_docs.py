#!/usr/bin/env python3
"""
GameParadise Documentation Auto-Updater
Automatically updates documentation when code changes are detected.
"""

import os
import re
import json
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Set

class DocUpdater:
    def __init__(self, project_root: str):
        self.root = Path(project_root)
        self.scripts_dir = self.root / "games"
        self.core_dir = self.root
        self.last_update_file = self.root / ".doc_update_cache.json"
        self.load_cache()

    def load_cache(self):
        """Load last update timestamps."""
        if self.last_update_file.exists():
            with open(self.last_update_file) as f:
                self.cache = json.load(f)
        else:
            self.cache = {}

    def save_cache(self):
        """Save update timestamps."""
        with open(self.last_update_file, 'w') as f:
            json.dump(self.cache, f)

    def get_changed_files(self) -> Set[Path]:
        """Find all changed .gd files since last update."""
        changed = set()
        
        for gd_file in self.root.rglob("*.gd"):
            if ".godot" in str(gd_file):
                continue
            
            mtime = os.path.getmtime(gd_file)
            cached_mtime = self.cache.get(str(gd_file), 0)
            
            if mtime > cached_mtime:
                changed.add(gd_file)
                self.cache[str(gd_file)] = mtime
        
        return changed

    def extract_functions(self, file_path: Path) -> List[Dict]:
        """Extract function signatures from GDScript file."""
        functions = []
        with open(file_path) as f:
            content = f.read()
        
        # Match: func name(params) -> return_type:
        pattern = r'func\s+(_?\w+)\s*\((.*?)\)\s*(?:->\s*(\w+))?:'
        
        for match in re.finditer(pattern, content):
            func_name, params, return_type = match.groups()
            functions.append({
                'name': func_name,
                'params': params.strip(),
                'return': return_type or 'void',
                'file': file_path.name
            })
        
        return functions

    def extract_signals(self, file_path: Path) -> List[str]:
        """Extract signal definitions from GDScript file."""
        signals = []
        with open(file_path) as f:
            content = f.read()
        
        pattern = r'signal\s+(\w+)\s*(?:\((.*?)\))?'
        
        for match in re.finditer(pattern, content):
            signal_name, params = match.groups()
            signals.append(f"{signal_name}({params or ''})")
        
        return signals

    def extract_constants(self, file_path: Path) -> List[Dict]:
        """Extract constants from GDScript file."""
        constants = []
        with open(file_path) as f:
            content = f.read()
        
        pattern = r'const\s+(\w+)\s*:\s*(\w+)\s*=\s*([^\n]+)'
        
        for match in re.finditer(pattern, content):
            name, type_, value = match.groups()
            constants.append({
                'name': name,
                'type': type_,
                'value': value.strip()
            })
        
        return constants

    def update_quick_reference(self, changed_files: Set[Path]):
        """Update QUICK_REFERENCE.md with new functions and signals."""
        quick_ref = self.root / "QUICK_REFERENCE.md"
        
        all_functions = {}
        all_signals = {}
        all_constants = {}
        
        for file_path in changed_files:
            if file_path.suffix != ".gd":
                continue
            
            functions = self.extract_functions(file_path)
            signals = self.extract_signals(file_path)
            constants = self.extract_constants(file_path)
            
            if functions:
                all_functions[file_path.stem] = functions
            if signals:
                all_signals[file_path.stem] = signals
            if constants:
                all_constants[file_path.stem] = constants
        
        if not (all_functions or all_signals or all_constants):
            return
        
        with open(quick_ref) as f:
            content = f.read()
        
        # Update functions section
        if all_functions:
            func_section = self._generate_functions_section(all_functions)
            content = self._update_section(content, "## Common Code Patterns", func_section)
        
        # Update signals section
        if all_signals:
            signal_section = self._generate_signals_section(all_signals)
            content = self._update_section(content, "## Signals", signal_section)
        
        # Update constants section
        if all_constants:
            const_section = self._generate_constants_section(all_constants)
            content = self._update_section(content, "## Game Constants", const_section)
        
        with open(quick_ref, 'w') as f:
            f.write(content)

    def _generate_functions_section(self, functions: Dict) -> str:
        """Generate functions documentation."""
        section = "\n### New Functions\n\n"
        for file, funcs in functions.items():
            section += f"**{file}.gd**\n"
            for func in funcs:
                section += f"- `{func['name']}({func['params']}) -> {func['return']}`\n"
            section += "\n"
        return section

    def _generate_signals_section(self, signals: Dict) -> str:
        """Generate signals documentation."""
        section = "\n### New Signals\n\n"
        for file, sigs in signals.items():
            section += f"**{file}.gd**\n"
            for sig in sigs:
                section += f"- `{sig}`\n"
            section += "\n"
        return section

    def _generate_constants_section(self, constants: Dict) -> str:
        """Generate constants documentation."""
        section = "\n### New Constants\n\n"
        for file, consts in constants.items():
            section += f"**{file}.gd**\n"
            for const in consts:
                section += f"- `{const['name']}: {const['type']} = {const['value']}`\n"
            section += "\n"
        return section

    def _update_section(self, content: str, marker: str, new_section: str) -> str:
        """Update or insert section in document."""
        if marker in content:
            # Find section and replace until next heading
            pattern = f"({re.escape(marker)}.*?)(?=\n## |\Z)"
            content = re.sub(pattern, marker + new_section, content, flags=re.DOTALL)
        else:
            # Append to end
            content += new_section
        return content

    def update_architecture_doc(self, changed_files: Set[Path]):
        """Update ARCHITECTURE.md with new patterns."""
        arch_doc = self.root / "ARCHITECTURE.md"
        
        # Check for new game directories
        games_dir = self.root / "games"
        new_games = []
        
        for game_dir in games_dir.iterdir():
            if game_dir.is_dir() and not game_dir.name.startswith('.'):
                game_name = game_dir.name
                if game_name not in self.cache.get("documented_games", []):
                    new_games.append(game_name)
        
        if not new_games:
            return
        
        with open(arch_doc) as f:
            content = f.read()
        
        # Add new games to extension section
        new_game_section = "\n### New Games Added\n\n"
        for game in new_games:
            new_game_section += f"- **{game}** - See `games/{game}/` directory\n"
        
        content = self._update_section(content, "## Extending the Architecture", new_game_section)
        
        with open(arch_doc, 'w') as f:
            f.write(content)
        
        if "documented_games" not in self.cache:
            self.cache["documented_games"] = []
        self.cache["documented_games"].extend(new_games)

    def update_fixes_needed(self, changed_files: Set[Path]):
        """Update FIXES_NEEDED.md if critical issues found."""
        fixes_file = self.root / "FIXES_NEEDED.md"
        
        issues = []
        for file_path in changed_files:
            if file_path.suffix != ".gd":
                continue
            
            with open(file_path) as f:
                content = f.read()
            
            # Check for common issues
            if "push_error" in content and "if not" not in content:
                issues.append(f"Missing null checks in {file_path.name}")
            
            if re.search(r'= \d+\.?\d*', content):
                issues.append(f"Hardcoded values in {file_path.name}")
            
            if not re.search(r'##\s+\w+', content):
                issues.append(f"Missing JSDoc comments in {file_path.name}")
        
        if not issues:
            return
        
        with open(fixes_file) as f:
            content = f.read()
        
        issue_section = "\n### Recently Detected Issues\n\n"
        for issue in issues:
            issue_section += f"- [ ] {issue}\n"
        
        content = self._update_section(content, "## SUMMARY", issue_section)
        
        with open(fixes_file, 'w') as f:
            f.write(content)

    def generate_changelog_entry(self, changed_files: Set[Path]) -> str:
        """Generate changelog entry for changes."""
        if not changed_files:
            return ""
        
        entry = f"\n## [{datetime.now().strftime('%Y-%m-%d')}]\n\n### Changed\n"
        
        for file_path in sorted(changed_files):
            if file_path.suffix == ".gd":
                entry += f"- Updated {file_path.relative_to(self.root)}\n"
        
        return entry

    def update_changelog(self, changed_files: Set[Path]):
        """Update CHANGELOG.md with new changes."""
        changelog = self.root / "CHANGELOG.md"
        
        entry = self.generate_changelog_entry(changed_files)
        if not entry:
            return
        
        if changelog.exists():
            with open(changelog) as f:
                content = f.read()
            content = entry + content
        else:
            content = "# GameParadise Changelog\n" + entry
        
        with open(changelog, 'w') as f:
            f.write(content)

    def run(self):
        """Run documentation update."""
        changed_files = self.get_changed_files()
        
        if not changed_files:
            print("✓ No changes detected")
            return
        
        print(f"📝 Found {len(changed_files)} changed files")
        
        self.update_quick_reference(changed_files)
        print("✓ Updated QUICK_REFERENCE.md")
        
        self.update_architecture_doc(changed_files)
        print("✓ Updated ARCHITECTURE.md")
        
        self.update_fixes_needed(changed_files)
        print("✓ Updated FIXES_NEEDED.md")
        
        self.update_changelog(changed_files)
        print("✓ Updated CHANGELOG.md")
        
        self.save_cache()
        print("✓ Cache saved")
        print(f"✅ Documentation updated at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")


def main():
    """Main entry point."""
    import sys
    
    project_root = sys.argv[1] if len(sys.argv) > 1 else "."
    
    if not Path(project_root).exists():
        print(f"❌ Project root not found: {project_root}")
        return 1
    
    updater = DocUpdater(project_root)
    updater.run()
    return 0


if __name__ == "__main__":
    exit(main())
