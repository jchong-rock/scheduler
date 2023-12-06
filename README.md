
# incident.io scheduler

This is my solution to the incident.io scheduling take home test.
https://github.com/incident-io/internships

I have used Objective-C to write this code.

## Software engineering techniques

I used test-driven development (TDD) techniques to produce a project with a simple implementation and easy to maintain code. Additionally, I have decoupled classes as much as possible, in order to make refactoring and replacing classes easier.

## Code structure

The code relies on five key classes:

### Scheduler
The `Scheduler` class implements a round robin scheduling algorithm and provides a mechanism to constrain any timetables produced between the start and end dates given in the program arguments. It also provides an interface to schedule overrides.

### Schedule
The `Schedule` class holds a table of allocations for each user and provides interfaces to schedule a given user for a given time slot. It has no concept of overriding but will truncate existing allocations if a new allocation is made which clashes with an existing one.

### FileReader
The `FileReader` protocol provides a template for reading users, overrides, and other scheduling information from a file. A concrete implementation, `JSONReader`, is provided to read this information from a JSON file as described by incident.io.

### Timeslot
The `Timeslot` class holds a pair of dates representing the start and end points of a time slot. It also provides a static method for finding and truncating `Timeslot`s representing overlapping periods of time.

### DateUtils
The `DateUtils` class provides static methods to convert between the internal representation of a date and the ISO date format required for output, as well as a method to convert a `Schedule` to a string in the required format. Note that this is different from the `description` method in the `Schedule` class which is only used for debugging.

## Trying it out

To run the code, use Xcode 14.0.1 or higher to compile the project. Pass in the arguments in the following format:

`scheduler --schedule=<path to schedule json> --overrides=<path to schedule json> --from=<start date in ISO format> --until=<end date in ISO format>`


## Running the test suite

Included is a test suite which provides unit tests for the `Scheduler`, `Schedule`, and `JSONReader` classes. These tests were used during development for the TDD technique as described above. To run the test suite, pass in arguments in the following format:

`scheduler --test <path to 'files' folder>`

The 'files' folder can be found in the test directory. It contains a number of files used for testing the `JSONReader`. These files may also be used to run the scheduler normally.

To add additional tests, create a class containing only instance methods which return BOOL and take no arguments, e.g.

MyTestClass.h
```
@interface MyTestClass : NSObject

- (BOOL) myTestName;

@end
```

MyTestClass.m
```
@implementation MyTestClass

- (BOOL) myTestName {
    return YES;
}

@end
```

Return `YES` on branches that cause the test to pass and `NO` on branches that cause the test to fail. You can also make use of the `Assert(expr)` macro, which fails the test if the BOOL condition `expr` returns `NO`, as well as printing the statement that caused the assertion failure.

To add these tests to the test suite, find the `int test(char const * inputPath)` function and add the name of your test class to the `testClasses` array. Remember to prefix the string name of your class with an `@` to declare it as an Objective-C string.

## Further development

The codebase is intentionally designed to be extensible to allow futher development. For example, the `User` type is currently a `typedef` for `NSString`, but this could be changed to a fully-fledged class if we needed to add more properties to User. We would need to implement the `NSCopying` protocol to allow this type to be used in a dictionary, and we would need to modify the test suite and `JSONReader` which currently use string literals to create users.

