    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
    }
extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCartEvents().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell") as! EventTableViewCell
        cell.reloadWith(event: viewModel.getCartEvents()[indexPath.row])
        cell.delegate = self
        return cell
        
    }
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
