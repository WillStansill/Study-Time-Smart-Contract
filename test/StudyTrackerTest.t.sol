//SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import {Test} from "../lib/forge-std/src/Test.sol";
import {StudyTracker} from "../src/StudyTracker.sol";
import {console2} from "lib/forge-std/src/console2.sol";

contract StudyTrackerTest is Test {
    StudyTracker studyTracker;

    address notTheOwner;

    function setUp() external {
        studyTracker = new StudyTracker();
    }

    function testStartCanOnlyBeCalledWhenOff() public {
        studyTracker.startTimer();
        vm.expectRevert(StudyTracker.ClockStillRunning.selector);
        studyTracker.startTimer();
    }

    function testTimerIsActuallyRunning() public {
        studyTracker.startTimer();
        vm.warp(block.timestamp + 100000);
        uint256 currentTime = studyTracker.getCurrentTime();
        assertGt(currentTime, 100);
    }

    function testOnlyOwnerCanAffectClockState() public {
        vm.prank(notTheOwner);
        vm.expectRevert(StudyTracker.NotOwner.selector);
        studyTracker.startTimer();
    }

    function testClockStateStartsFalse() public view {
        assert(studyTracker.ClockState() == false);
    }

    function testTimerMustBeOnToStop() public {
        vm.expectRevert(StudyTracker.ClockNotRunning.selector);
        studyTracker.stopTimer();
    }

    function testSaveSessionSavesSession() public {
        studyTracker.startTimer();
        vm.warp(block.timestamp + 100000);
        studyTracker.stopTimer();
        studyTracker.saveSession();
        console2.log(studyTracker.studySessions(0));
        assert(studyTracker.getNumberOfStudySessions() > 0);
    }

    function testTotalStudyTimeIsCorrect() public {
        studyTracker.startTimer();
        vm.warp(block.timestamp + 100000);
        studyTracker.stopTimer();
        studyTracker.saveSession();
        studyTracker.getTotalStudyTime();
        studyTracker.startTimer();
        vm.warp(block.timestamp + 100000);
        studyTracker.stopTimer();
        studyTracker.saveSession();
        studyTracker.getTotalStudyTime();
        studyTracker.startTimer();
        vm.warp(block.timestamp + 100000);
        studyTracker.stopTimer();
        studyTracker.saveSession();
        studyTracker.getTotalStudyTime();
        assert(studyTracker.getTotalStudyTime() == 300000);
    }

    function testGetCurrentTime() public {
        studyTracker.startTimer();
        vm.warp(block.timestamp + 100000);
        assert(studyTracker.getCurrentTime() == 100000);
    }

    function testGetStudySessionLength() public {
        studyTracker.startTimer();
        vm.warp(block.timestamp + 100000);
        studyTracker.stopTimer();
        studyTracker.saveSession();
        uint256 sessionLength = studyTracker.studySessions(0);
        assertEq(studyTracker.getStudySessionLength(0), sessionLength);
    }

    function testSaveSessionResetsTimer() public {
        studyTracker.startTimer();
        vm.warp(block.timestamp + 100000);
        studyTracker.stopTimer();
        studyTracker.saveSession();
        assertEq(studyTracker.getCurrentTime(), 0);
        assertEq(studyTracker.StartingTime(), 0);
    }

    function testTimerState() public {
        assert(studyTracker.getTimerState() == false);
        studyTracker.startTimer();
        assert(studyTracker.getTimerState() == true);
    }

    function testgetStudySessionLengthBadIndex() public {
        studyTracker.startTimer();
        vm.warp(block.timestamp + 100000);
        studyTracker.stopTimer();
        studyTracker.saveSession();
        vm.expectRevert(StudyTracker.InvalidIndex.selector);
        studyTracker.getStudySessionLength(7);
    }
    function testResetTimerOnlyOwner() public {
        studyTracker.startTimer();
        vm.warp(block.timestamp + 1000);
        studyTracker.stopTimer();

        vm.prank(address(0xBEEF));
        vm.expectRevert(StudyTracker.NotOwner.selector);
        studyTracker.saveSession();
    }
    function testGetCurrentTimeAfterStop() public {
        studyTracker.startTimer();
        vm.warp(block.timestamp + 1234);
        studyTracker.stopTimer();
        uint256 timeAfterStop = studyTracker.getCurrentTime();
        assertEq(timeAfterStop, 1234);
    }
    function testResetTimerFailsIfClockStillRunning() public {
        studyTracker.startTimer();
        vm.warp(block.timestamp + 1234);
        // timer is still running here
        vm.expectRevert(StudyTracker.ClockStillRunning.selector);
        studyTracker.saveSession(); // calls resetTimer internally
    }
    function testOwnerIsSetCorrectly() public {
        assertEq(studyTracker.getOwner(), address(this));
    }
}
