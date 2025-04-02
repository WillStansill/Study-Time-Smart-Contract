//SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

error NotOwner();
error ClockNotRunning();
error ClockStillRunning();
error InvalidIndex();

contract StudyTracker {
    address owner = msg.sender;

    modifier onlyOwner() {
        if (owner != msg.sender) {
            revert NotOwner();
        }
        _;
    }

    modifier timerOn() {
        if (ClockState == false) {
            revert ClockNotRunning();
        }
        _;
    }
    modifier timerOff() {
        if (ClockState == true) {
            revert ClockStillRunning();
        }
        _;
    }

    uint256[] studySessions;

    bool ClockState = false;
    uint256 StartingTime;
    uint256 EndingTime;
    uint256 SessionLength;

    function startTimer() public onlyOwner timerOff returns (uint256) {
        StartingTime = block.timestamp;
        ClockState = true;
        return StartingTime;
    }

    function stopTimer() public onlyOwner timerOn returns (uint256) {
        EndingTime = block.timestamp;
        ClockState = false;
        return EndingTime;
    }

    function saveSession() public onlyOwner timerOff {
        uint256 sessionTime = (EndingTime - StartingTime);
        studySessions.push(sessionTime);
        resetTimer();
    }

    function resetTimer() internal onlyOwner timerOff {
        StartingTime = 0;
        EndingTime = 0;
    }

    function getStudySessionLength(
        uint256 studySessionIndex
    ) public view returns (uint256) {
        if (studySessionIndex >= studySessions.length) {
            revert InvalidIndex();
        }
        return studySessions[studySessionIndex];
    }

    function getTotalStudyTime() public view returns (uint256 totalTime) {
        for (
            uint256 studySessionIndex = 0;
            studySessionIndex < studySessions.length;
            studySessionIndex++
        ) {
            totalTime += studySessions[studySessionIndex];
        }
        return totalTime;
    }

    function getTimerState() public view returns (bool timerState) {
        return ClockState;
    }
}
