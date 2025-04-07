# StudyTracker Smart Contract

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Solidity](https://img.shields.io/badge/Solidity-%3E=0.8.28-lightgrey)
![Foundry](https://img.shields.io/badge/Foundry-v0.7.x+-blueviolet)

<p align="center">
  <img src="https://placehold.co/400x200/EEE/31343C?text=StudyTracker&font=Montserrat" alt="StudyTracker Logo" />
</p>

## Overview

The StudyTracker smart contract is a decentralized application designed to help individuals track their study sessions directly on the Ethereum blockchain.  This eliminates the need for centralized tracking applications and provides a transparent, immutable record of study time.  The contract is written in Solidity and utilizes the Foundry development toolchain for efficient testing and deployment.

## Features

* **Session Management**
    * `startTimer()`:  Initiates a new study session by recording the starting timestamp.  Only the contract owner can call this function.  Reverts if a timer is already running.
    * `stopTimer()`:  Terminates the current study session, recording the ending timestamp and calculating the session duration.  Only the contract owner can call this function. Reverts if no timer is running.
    * `saveSession()`:  Stores the duration of a completed study session in the `studySessions` array.  Only the contract owner can call this function, and only when the timer is not running.
    * `resetTimer()`: Resets `StartingTime` and `EndingTime`.

* **Data Retrieval**
    * `getStudySessionLength(uint256 studySessionIndex)`: Retrieves the duration of a specific study session using its index.  Reverts if the provided index is invalid.
    * `getTotalStudyTime()`:  Calculates and returns the sum of all recorded study session durations.
    * `getNumberOfStudySessions()`: Returns the total number of study sessions recorded.
    * `getCurrentTime()`: Returns the elapsed time of the current study session, or the duration of the last session.
    * `getTimerState()`:  Returns a boolean indicating whether the timer is currently running.
    * `getOwner()`: Returns the address of the contract owner.

## Security Considerations

* **Owner-Only Functions:** The core functionality of this contract (starting, stopping, and saving sessions) is restricted to the contract owner, preventing unauthorized modification of study records.
* **Error Handling:** The contract includes error handling (using `revert`) to prevent invalid operations, such as starting a timer when one is already running or accessing an invalid session index.

## Getting Started

### Prerequisites

* **Foundry:** Ensure you have Foundry installed. Installation instructions can be found in [The Foundry Book](https://book.getfoundry.sh/).
* **Node.js and npm (Optional):** While not strictly required for basic usage with Foundry, Node.js and npm can be helpful for more advanced interaction, scripting, or frontend integration.

### Installation

1.  **Clone the Repository:**
    ```bash
    git clone <YOUR_REPOSITORY_URL>
    cd StudyTracker
    ```
    (Replace `<YOUR_REPOSITORY_URL>` with the actual URL of your repository.)

2.  **Build the Contract:**
    ```bash
    forge build
    ```

### Testing

To ensure the contract functions correctly, a comprehensive test suite is included.

1.  **Run Tests:**
    ```bash
    forge test
    ```

2.  **View Coverage Report (Optional):**
    ```bash
    forge coverage
    ```
    This will generate a report showing the percentage of your contract's code that is covered by the tests.

### Deployment

Deployment is handled using Foundry.  You'll need to configure your `foundry.toml` file with your network settings and private key.

1.  **Set up Environment Variables:**
    ```bash
    export PRIVATE_KEY="0xYourPrivateKey"
    export RPC_URL="[https://your-rpc-endpoint.com](https://www.google.com/search?q=https://your-rpc-endpoint.com)" # e.g., [http://127.0.0.1:8545](https://www.google.com/search?q=http://127.0.0.1:8545) for Anvil
    ```
    (Replace the values with your actual private key and RPC URL.)

2.  **Deploy:**
    ```bash
    forge create src/StudyTracker.sol:StudyTracker --private-key $PRIVATE_KEY --rpc-url $RPC_URL
    ```

    The output will show the contract address.

### Contract Interaction

Once deployed, you can interact with the StudyTracker contract using various methods.  Here are some examples using `cast`:

* **Using Cast:**

    * **Get Owner:**
        ```bash
        cast call <CONTRACT_ADDRESS> "getOwner()" --rpc-url $RPC_URL
        ```
    * **Start Timer:**
        ```bash
        cast send <CONTRACT_ADDRESS> "startTimer()" --private-key $PRIVATE_KEY --rpc-url $RPC_URL
        ```
    * **Stop Timer:**
        ```bash
        cast send <CONTRACT_ADDRESS> "stopTimer()" --private-key $PRIVATE_KEY --rpc-url $RPC_URL
        ```
    * **Save Session:**
        ```bash
        cast send <CONTRACT_ADDRESS> "saveSession()" --private-key $PRIVATE_KEY --rpc-url $RPC_URL
        ```
    * **Get Session Length (at index 0):**
        ```bash
        cast call <CONTRACT_ADDRESS> "getStudySessionLength(uint256)" 0 --rpc-url $RPC_URL
        ```
    * **Get Total Study Time:**
        ```bash
        cast call <CONTRACT_ADDRESS> "getTotalStudyTime()"  --rpc-url $RPC_URL
        ```
     * **Get Number of Sessions:**
        ```bash
        cast call <CONTRACT_ADDRESS> "getNumberOfStudySessions()" --rpc-url $RPC_URL
        ```
    * **Get Timer State:**
        ```bash
        cast call <CONTRACT_ADDRESS> "getTimerState()" --rpc-url $RPC_URL
        ```
     * **Get Current Time:**
        ```bash
        cast call <CONTRACT_ADDRESS> "getCurrentTime()" --rpc-url $RPC_URL
        ```

    (Replace `<CONTRACT_ADDRESS>` with the address of your deployed contract.)

* **Web3 Libraries (Ethers.js/Web3.js):** For integration into web applications, you can use JavaScript libraries like Ethers.js or Web3.js.

## Contract Architecture



.
├── foundry.toml # Foundry project configuration
├── lib/
│ └── forge-std/ # Foundry Standard Library
│ └── ...
├── src/
│ └── StudyTracker.sol # Solidity contract
└── test/
│ └── StudyTrackerTest.t.sol # Foundry test suite
## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.


