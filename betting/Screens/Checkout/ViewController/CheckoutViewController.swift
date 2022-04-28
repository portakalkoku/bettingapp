//
//  CheckoutViewController.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 27.04.2022.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(.init(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        }
    }
    @IBOutlet weak var maxReturnLabel: UILabel! {
        didSet {
            maxReturnLabel.text = viewModel.getMultiplier()
        }
    }
    @IBOutlet weak var feeTextField: UITextField! {
        didSet {
            feeTextField.text = "1.0"
            feeTextField.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var emptyView: UIView! {
        didSet {
            emptyView.isHidden = true
        }
    }
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: - Init
    let viewModel: CheckoutViewModelProtocol
    init(
        viewModel: CheckoutViewModelProtocol
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - IBActions
    @IBAction func didChangeText(_ sender: Any) {
        guard let text = feeTextField.text, let double = Double(text) else {
            viewModel.calculateMaxReturn(value: 1.0)
            return
        }
        viewModel.calculateMaxReturn(value: double)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
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

// MARK: - CheckoutViewModelDelegate
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

// MARK: - EventTableViewCellDelegate
extension CheckoutViewController: EventTableViewCellDelegate {
    func didTapRemoveEventFromCart(event: CartModels.Event) {
        viewModel.removeEventFromCart(event: event)
    }
}
