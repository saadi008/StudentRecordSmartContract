// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StudentRecord {

    //Contract Owner
    address public owner;

    //Constructor
    constructor() {
        owner = msg.sender;
    }

    //Student Structure
    struct Student {
        uint256 studentId;
        string name;
        string department;
        uint256 semester;
        uint256 cgpa;
        bool isActive;
    }

    //Mapig to store students
    mapping (uint256 => Student) public students;

    //Total Students
    uint256 public studentCount;

    //Modifier to allow only Owner
    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    //Events
    event StudentAdded(uint256 studentId, string name);
    event StudentUpdated(uint256 studentId, string name);
    event StudentDeleted(uint256 studentId);

        // Add a new student
    function addStudent(
        uint256 _studentId,
        string memory _name,
        string memory _department,
        uint256 _semester,
        uint256 _cgpa
    ) public onlyOwner {

        require(!students[_studentId].isActive, "Student already exists");

        students[_studentId] = Student(
            _studentId,
            _name,
            _department,
            _semester,
            _cgpa,
            true
        );

        studentCount++;

        emit StudentAdded(_studentId, _name);
    }

        // Get student details
    function getStudent(uint256 _studentId)
        public
        view
        returns (
            uint256,
            string memory,
            string memory,
            uint256,
            uint256,
            bool
        )
    {
        Student memory student = students[_studentId];

        require(student.isActive, "Student not found");

        return (
            student.studentId,
            student.name,
            student.department,
            student.semester,
            student.cgpa,
            student.isActive
        );
    }

        // Update student details
    function updateStudent(
        uint256 _studentId,
        string memory _name,
        string memory _department,
        uint256 _semester,
        uint256 _cgpa
    ) public onlyOwner {

        require(students[_studentId].isActive, "Student not found");

        students[_studentId].name = _name;
        students[_studentId].department = _department;
        students[_studentId].semester = _semester;
        students[_studentId].cgpa = _cgpa;

        emit StudentUpdated(_studentId, _name);
    }

        // Delete student record
    function deleteStudent(uint256 _studentId) public onlyOwner {

        require(students[_studentId].isActive, "Student not found");

        delete students[_studentId];

        studentCount--;

        emit StudentDeleted(_studentId);
    }

        // Get total number of students
    function getStudentCount() public view returns (uint256) {
        return studentCount;
    }
}