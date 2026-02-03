# Testing the Dotfiles Libraries

This directory contains automated tests for the shell script libraries using
BATS (Bash Automated Testing System).

## Prerequisites

### Install BATS

**Ubuntu/Debian:**

```bash
sudo apt install bats
```

**macOS:**

```bash
brew install bats-core
```

**From source:**

```bash
git clone https://github.com/bats-core/bats-core.git
cd bats-core
sudo ./install.sh /usr/local
```

## Running Tests

### Run all tests

```bash
bats tests/*.bats
```

### Run specific test file

```bash
bats tests/test_log.bats
bats tests/test_print.bats
bats tests/test_prompt.bats
```

### Run with verbose output

```bash
bats -t tests/*.bats
```

### Run with pretty formatting

```bash
bats --formatter pretty tests/*.bats
```

## Test Structure

Each library has its own test file:

- `test_log.bats` - Tests for `lib/log.sh`
- `test_print.bats` - Tests for `lib/print.sh`
- `test_prompt.bats` - Tests for `lib/prompt.sh`

## Testing Interactive Functions

Interactive functions (like `prompt_yes_no`, `prompt_input`) are tested using:

1. **Input redirection** - Piping input to the function
2. **Process substitution** - Using `printf` to simulate multiple inputs
3. **Bash subshells** - Running in isolated environment

Example:

```bash
# Test prompt_yes_no with 'y' input
echo 'y' | prompt_yes_no 'Continue?'

# Test with multiple inputs (for retry scenarios)
printf 'invalid\nvalid\n' | prompt_choice 'Select:' 'A' 'B'
```

## Writing New Tests

### Basic test structure

```bash
@test "description of what is being tested" {
  run your_command arg1 arg2

  # Check exit status
  [ "$status" -eq 0 ]

  # Check output
  [[ "$output" == "expected output" ]]

  # Check output contains text
  [[ "$output" =~ "partial match" ]]
}
```

### Testing functions with input

```bash
@test "function accepts user input" {
  run bash -c "source lib/yourlib.sh; echo 'input' | your_function"
  [ "$status" -eq 0 ]
  [[ "$output" == "expected" ]]
}
```

### Setup and teardown

```bash
setup() {
  # Runs before each test
  source lib/yourlib.sh
  export TEST_VAR="value"
}

teardown() {
  # Runs after each test
  rm -f /tmp/test-files
}
```

## CI/CD Integration

### GitHub Actions

```yaml
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install BATS
        run: sudo apt-get install -y bats
      - name: Run tests
        run: bats tests/*.bats
```

### GitLab CI

```yaml
test:
  image: ubuntu:latest
  before_script:
    - apt-get update
    - apt-get install -y bats
  script:
    - bats tests/*.bats
```

## Expected Output

When all tests pass:

```bash
✓ log_info outputs correct format
✓ log_success outputs correct format
✓ log_warn outputs correct format
✓ log_error outputs to stderr
...

25 tests, 0 failures
```

When tests fail:

```bash
✗ log_info outputs correct format
  (in test file test_log.bats, line 15)
  `[[ "$output" == "[*] test message" ]]' failed

  expected: [*] test message
  actual:   [INFO] test message

1 test, 1 failure
```

## Coverage

Current test coverage:

- **log.sh**: ~90% (all log levels, filtering, file logging, commands)
- **print.sh**: ~95% (all print functions, formatting)
- **prompt.sh**: ~85% (all prompt types, validation, defaults)

## Troubleshooting

### Tests fail with "command not found"

- Make sure BATS is installed correctly
- Check that libraries are in the correct path

### Interactive tests hang

- Ensure you're piping input correctly
- Use `printf` for multiple inputs, not `echo`
- Tests should not wait for actual user input

### Color-related failures

- Set `LOG_COLORS=false` and `PRINT_COLORS=false` in setup
- This ensures consistent output for assertions

## Resources

- [BATS Documentation](https://bats-core.readthedocs.io/)
- [BATS GitHub](https://github.com/bats-core/bats-core)
- [Testing Bash with BATS](https://opensource.com/article/19/2/testing-bash-bats)
