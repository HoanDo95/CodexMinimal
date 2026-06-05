#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn returns_expected_value() {
        assert_eq!(function_under_test(), "ok");
    }
}
