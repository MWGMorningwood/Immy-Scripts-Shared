# Community Immy Scripts
> [!WARNING]  
> The scripts involved rely on immy.bot metascript functions that are only available in immy.bot.  
> This repository is for immy-specific PowerShell; a generic version may be added elsewhere.
> Additionally, these scripts are **not** official, nor do they have any guarantee backing them.
> Any script found in this repository is given to the community by the community.

## Welcome!
The Immybot Community Script Library is a collaborative space where developers and IT professionals can share, discover, and contribute scripts designed to enhance the deployment capabilities of Immybot.  
Our goal is to create a comprehensive repository of scripts that can be used to automate and streamline various deployment tasks, making it easier for everyone to achieve efficient and reliable deployments.  

Until we're allowed to PR into global, this is our solution!

## Contribution Guidelines
We encourage all community members to contribute to the library. Here are some general guidelines to help you get started:

### Practices
* **Quality and Clarity**: Ensure your scripts are well-documented and easy to understand. Include comments where necessary.  
* **Testing**: Test your scripts thoroughly before submitting. Make sure they work as intended and do not cause any unintended side effects.  
* **Pull Requests**: Submit your contributions via pull requests. Provide a detailed description of what your script does and any dependencies it may have. PRs to main will not be accepted.  
* **Respect and Collaboration**: Be respectful and open to feedback from other community members. Collaboration is key to building a robust script library.
* **Organization**: Scripts that have a common usage (like software install/uninstall/versioning) should be foldered by the item they are for.  

### Standards
* **Variables**: Should be in [CamelCase](https://en.wikipedia.org/wiki/Camel_case).  
* **Indentation**: Should be done with four spaces.  
* **Bracing**: Should be done with [K&R OTBS](https://github.com/PoshCode/PowerShellPracticeAndStyle/issues/81#issuecomment-285835313)  

## Definitions and Terminology
**Script Context**:
  * Metascript: A script that runs on the Immybot instance and remotely communicates with endpoints similar to PSRemote.
  * Cloud script: A script that runs on the Immybot instance and is not intended to interact with any endpoints.
  * System: A script that executes locally in the endpoint's system context.
  * User: A script that executes locally in the endpoint's logged-in user's context.
