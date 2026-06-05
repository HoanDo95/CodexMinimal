#[test]
fn reproduces_the_reported_bug() {
    let err = function_under_test().unwrap_err();
    assert!(!err.to_string().is_empty());
}
