set -e

echo "Running Python test..."
python3 tests/test.py

echo "Running Go test..."
go run tests/test.go

echo "Running Java test..."
javac tests/Test.java && java -cp tests Test

echo "Running Node.js test..."
node tests/test.js

echo "Running C# test..."
dotnet new console -o csharp_test -n TestApp
cp tests/Test.cs csharp_test/Program.cs
cd csharp_test
dotnet run
cd ..
