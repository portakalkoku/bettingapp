    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
    }
extension CheckoutViewController: CheckoutViewModelDelegate {
    func reloadTableView() {
        emptyView.isHidden = true
        stackView.isHidden = false
        tableView.isHidden = false
        tableView.reloadData()
    }

    func showEmptyScreen() {
        emptyView.isHidden = false
        stackView.isHidden = true
        tableView.isHidden = true
    }
    
    func reloadMultiplier(with value: Double) {
        maxReturnLabel.text = value.convertToTwoDecimalString()
    }
}
