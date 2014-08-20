part of alpha.test.async;

void helpers() {
  test("asynchronous execution properly runs", () {
    var something = false;
    var done = expectAsync(() {
      expect(something, isTrue);
    });
    
    async(() {
      something = true;
      done();
    });
  });
}