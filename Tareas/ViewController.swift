//  ViewController.swift
//  Tareas
//
//  Created by Federico Ruiz on 30/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableview: UITableView! // variable para manejar nuestra table view vista
    
    var tasks = [String]() // Un array donde voy a almacenar mis tareas
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tareas"
        tableview.delegate = self
        tableview.dataSource = self
        
        // SetUp
        
        if !UserDefaults().bool(forKey: "setup"){
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
            
        }
        
        updateTasks()
        
    }
    
    func updateTasks(){
        
        tasks.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        for x in 0..<count{
            
            if let task = UserDefaults().value(forKey: "task_\(x+1)") as? String{
                
                tasks.append(task)
            }
            
        }
        
        tableview.reloadData()
    }
    
    // Instanciamos
    
    @IBAction func didTapAdd() {
        
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async{
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
// Le asignamos el delegado
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        vc.title = "New Task"
        vc.task = tasks[indexPath.row]
        navigationController?.pushViewController(vc,animated:true)

    }
    
}

//Va contar la cantidad de filas de mi tabla

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // devuelve la fila seleccionada una celda
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
}

