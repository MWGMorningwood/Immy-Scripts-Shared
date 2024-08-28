## Contribution Guidelines
We encourage all community members to contribute to the library. Here are some general guidelines to help you get started:

### How to Contribute
1. Fork the Repository: Start by forking the repository to your GitHub account.
2. Clone Your Fork: Clone your forked repository to your local machine.  
   ```sh
   git clone https://github.com/MWGMorningwood/Immy-Scripts-Shared.git
   ```
3. Create a Branch: Create a new branch for your feature or bug fix.
   ```sh
   git checkout -b feature/your-feature-name
   ```
4. Make Changes: Make your changes to the PowerShell scripts. Ensure your code follows the repository’s coding standards.
5. Commit Changes: Commit your changes with a clear and descriptive commit message.
   ```sh
   git commit -m "Add feature/fix description"
   ```
6. Push to GitHub: Push your changes to your forked repository.
   ```sh
   git push origin feature/your-feature-name
   ```
7. Create a Pull Request: Open a pull request from your branch to the our origin repository’s main branch. Provide a detailed description of your changes.

### Practices
* **BEST Practice**: Follow [Best Practice Guidelines](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/strongly-encouraged-development-guidelines?view=powershell-7.4)  
* **Quality and Clarity**: Ensure your scripts are well-documented and easy to understand. Include comments where necessary.  
* **Testing**: Test your scripts thoroughly before submitting. Make sure they work as intended and do not cause any unintended side effects.  
* **Pull Requests**: Submit your contributions via pull requests. Provide a detailed description of what your script does and any dependencies it may have. PRs to main will not be accepted.  
* **Organization**: Scripts that have a common usage (like software install/uninstall/versioning) should be foldered by the item they are for.  

### Standards
* **Variables**: Should be in [CamelCase](https://en.wikipedia.org/wiki/Camel_case).  
* **Indentation**: Should be done with four spaces.  
* **Bracing**: Should be done with [K&R OTBS](https://github.com/PoshCode/PowerShellPracticeAndStyle/issues/81#issuecomment-285835313)  
