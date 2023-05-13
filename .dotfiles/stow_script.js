const fs = require('fs');
const os = require('os');
const { spawnSync } = require('child_process');

const CONFIG_FILE = 'dotfilesConfig.json';

// Read the JSON configuration file
const config = JSON.parse(fs.readFileSync(CONFIG_FILE, 'utf8'));

// Check if 'stow' command is available
if (spawnSync('which', ['stow']).status !== 0) {
  console.error("Error: 'stow' command not found. Please install 'stow' to manage symlinks.");
  process.exit(1);
}

// Loop through each package in the configuration file
for (const item of config) {
  const { package: packageName, target: targetDirectory } = item;

  const resolvedTargetDirectory = targetDirectory.replace('~', os.homedir());

  // Run 'stow' command with the appropriate arguments
  const stowProcess = spawnSync('stow', ['--target=' + resolvedTargetDirectory, packageName], { stdio: 'inherit' });

  // Check the exit code of the 'stow' process
  if (stowProcess.status !== 0) {
    console.error(`Error occurred while stowing '${packageName}' package. Exit code: ${stowProcess.status}`);
    process.exit(1);
  }
}
