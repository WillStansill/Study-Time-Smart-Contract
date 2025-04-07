//SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import {Script} from "../lib/forge-std/src/Script.sol";
import {StudyTracker} from "../src/StudyTracker.sol";

contract DeployStudyTracker is Script {
    function run() external returns (StudyTracker) {
        vm.startBroadcast();
        StudyTracker studyTracker = new StudyTracker();
        vm.stopBroadcast();
        return studyTracker;
    }
}
