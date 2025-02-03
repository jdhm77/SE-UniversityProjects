package gui;

import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import methods.Calculation;
import items.Item;

public class Gui {
	// Extra Points GUI
	private JFrame frame;
	private JTextField laptopsTextField;
	private JTextField lcdTextField;
	private JTextField mouseTextField;
	private JTextField desktopTextField;

	public static void main(String[] args) {

	}

	public void OrderGUI() {
		frame = new JFrame("Shipping Company");
		frame.setBounds(100, 100, 400, 300);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);
		frame.setLocationRelativeTo(null);

		JLabel startOrder = new JLabel("START ORDER");
		startOrder.setBounds(120, 10, 130, 25);
		startOrder.setFont(new Font("Arial", Font.PLAIN, 15));
		frame.getContentPane().add(startOrder);

		JLabel Laptops = new JLabel("Laptop");
		Laptops.setBounds(10, 46, 62, 14);
		frame.getContentPane().add(Laptops);

		laptopsTextField = new JTextField();
		laptopsTextField.setBounds(80, 45, 175, 20);
		frame.getContentPane().add(laptopsTextField);

		JLabel LcdScreen = new JLabel("LCD Screen");
		LcdScreen.setBounds(10, 90, 80, 15);
		frame.getContentPane().add(LcdScreen);

		lcdTextField = new JTextField();
		lcdTextField.setBounds(80, 90, 175, 20);
		frame.getContentPane().add(lcdTextField);

		JLabel Mouse = new JLabel("Mouse");
		Mouse.setBounds(10, 135, 60, 15);
		frame.getContentPane().add(Mouse);

		mouseTextField = new JTextField();
		mouseTextField.setBounds(80, 135, 175, 20);
		frame.getContentPane().add(mouseTextField);

		JLabel Desktop = new JLabel("Desktop");
		Desktop.setBounds(10, 183, 62, 14);
		frame.getContentPane().add(Desktop);

		desktopTextField = new JTextField();
		desktopTextField.setBounds(80, 180, 175, 20);
		frame.getContentPane().add(desktopTextField);

		JButton confirmOrder = new JButton("Confirm");
		confirmOrder.setBounds(230, 230, 100, 25);
		frame.getContentPane().add(confirmOrder);

		confirmOrder.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int laptopsqty, lcdqty, mouseqty, desktopqty;
				try {
					laptopsqty = Integer.parseInt(laptopsTextField.getText());
					lcdqty = Integer.parseInt(lcdTextField.getText());
					mouseqty = Integer.parseInt(mouseTextField.getText());
					desktopqty = Integer.parseInt(desktopTextField.getText());
				} catch (NumberFormatException ex) {
					JOptionPane.showMessageDialog(null, "ERROR. PLEASE ENTER A NUMERIC VALUE.");
					return;
				}
				ArrayList<Item> items = new ArrayList();
				items.add(new Item("Laptop", 60, 50, 50, 6.5, "kg", laptopsqty));
				items.add(new Item("LCD Screen", 120, 140, 80, 2.6, "kg", lcdqty));
				items.add(new Item("Mouse", 30, 30, 20, 200, "g", mouseqty));
				items.add(new Item("Desktop", 100, 150, 50, 20, "kg", desktopqty));
				Calculation calculation = new Calculation();

				calculation.addOrder(items);
				calculation.printOrder();
				frame.dispose();
			}
		});

		frame.setVisible(true);
	}
}
