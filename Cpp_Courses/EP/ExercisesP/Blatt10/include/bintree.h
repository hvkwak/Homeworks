#ifndef BINTREE_H
#define BINTREE_H

#include <cstddef>
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

template<typename T>
class BinTree {
private:
  struct Node {
    T data;
    Node *left, *right; // linker und rechter Unterbaum
  };
    
  Node* root; // Wurzel
    
  bool isElement(Node* node, T data) {
    if (node == nullptr)
      return false;
    if (node->data == data)
      return true;
    if (node->data < data)
      return isElement(node->right, data);
    return isElement(node->left, data);
  }
    
  void clear(Node* node) {
    if (node != nullptr) {
      clear(node->left);
      clear(node->right);
      delete node;
    }
  }
    
  Node* insert(Node *node, T data) {
    if (node == nullptr) {
      node = new Node;
      node->data = data;
      node->left = node->right = nullptr;
      return node;
    }
    if (node->data < data)
      node->right = insert(node->right, data);
    else if (node->data > data)
      node->left = insert(node->left, data);
    return node;
  }
    
  // Aufgabe 1a)
  void preOrder(Node *node) {
    // hier Code einfuegen
    if (node != nullptr) {
      std::cout << node->data << " ";
      preOrder(node->left);
      preOrder(node->right);
    } else {
      return;
    }
  }

  void preOrderASCII(Node *node) {

    if (node != nullptr) {
      printASCII(std::to_string(node->data));
      preOrderASCII(node->left);
      preOrderASCII(node->right);
      return;
    } else {
      return;
    }
  }
  
  // Aufgabe 1a)
  void inOrder(Node *node) {
    // hier Code einfuegen
    if (node != nullptr) {
      inOrder(node->left);
      std::cout << node->data << " ";
      inOrder(node->right);
    } else {
      return;
    }
  }
    
  // Aufgabe 1a)
  void postOrder(Node *node) {
    // hier Code einfuegen
    if (node != nullptr) {
      postOrder(node->left);
      postOrder(node->right);
      std::cout << node->data << " ";
      return;
    } else {
      return;
    }
  }
    
  // Aufgabe 1b)
  int height(Node *node) {
    // hier Code einfuegen
    if (node == nullptr) {
      return 0;
    } else {
      int hl = height(node->left);
      int hr = height(node->right);
      if (hl > hr) {
        return 1 + hl;
      } else {
        return 1 + hr;
      }
    }
  }

  // Aufgabe 1c)
  int count(Node *node) {
    // hier Code einfuegen
    if (node == nullptr) {
      return 0;
    } else {
      return 1 + count(node->left) + count(node->right);
    }
  }

  // Aufgabe 1d)
  void range(Node *node, T min, T max) {
    // hier Code einfuegen
    if (node != nullptr) {
      range(node->left, min, max);
      if (min <= node->data && node->data <= max) {
        std::cout << node->data << " ";
      }
      range(node->right, min, max);
      return;
    } else {
      return;
    }
  }
  
  void printASCII(std::string s) {
    for (int i = 0; i < s.length(); i++) {
      std::cout << (int)s[i] << " ";
    }
    std::cout << ",";
  }
    
public:
  BinTree() : root(nullptr) {
  }
    
  ~BinTree() {
    clear(root);
  }
    
  void clear() {
    clear(root);
    root = nullptr;
  }
    
  void insert(T x) {
    root = insert(root, x);
  }
    
  bool isElement(T x) {
    return isElement(root, x);
  }
    
  T rootData(){
    return root->data;
  }
    
  void preOrder() {
    preOrder(root);
    cout << endl;
  }
    
  void inOrder() {
    inOrder(root);
    cout << endl;
  }
    
  void postOrder() {
    postOrder(root);
    cout << endl;
  }
    
  int height() {
    return height(root);
  }
    
  int count() {
    return count(root);
  }
    
  void range(T min, T max){
    range(root, min, max);
  }
    
  // Aufgabe 1e)
  void rotateLeft(){
    // hier Code einfuegen
    if (root != nullptr && root->left != nullptr) {
      // root change
      Node *B = root->left;
      Node *A = root;
      root->left = B->right;
      root = B;
      B->right = A;
    }
    return;
  }

  void preOrderSave(const char * filename) {
    // https://stackoverflow.com/questions/10150468/how-to-redirect-cin-and-cout-to-files
    ofstream out = ofstream(filename, ios::out);
    auto *coutbuf = cout.rdbuf(); cout.rdbuf(out.rdbuf());
    preOrderASCII(root);
    cout.rdbuf(coutbuf);
  }

  void load(const char *filename) {

    // read file, keep it in a string.
    ifstream file(filename);
    if (!file.is_open()) {
      std::cerr << "Error opening file. " << filename << std::endl;
      return;
    }
    std::string text;
    while (std::getline(file, text)) {
      // read all lines
      cout << text << endl;
    }
    file.close();

    
    std::string delimiter1 = ","; // comma between numbers
    std::string delimiter2 = " ";   // space to tell digits
    size_t found1 = text.find(delimiter1);
    while (found1 != string::npos) {

      // this works only for integers in ASCII code.
      std::string subtext = text.substr(0, found1);
      std::string subtext_value = "";

      // substr this subtext to find digits.
      size_t found2 = subtext.find(delimiter2);
      while (found2 != string::npos) {
        std::string subsubtext = subtext.substr(0, found2);

        // convert to normal integer
        int value = atoi(subsubtext.c_str()) - 48;
        subtext_value = subtext_value + std::to_string(value);

        // update subtext.
        subtext = subtext.substr(found2 + delimiter2.size(), subtext.size() - found2);
        found2 = subtext.find(delimiter2);
      }
      int data = std::stoi(subtext_value);
      cout << "subtext value: " << data << ", insert this." << endl;
      insert(data);
      
      // use subtext2
      text = text.substr(found1 + delimiter1.size(), text.size() - found1);
      found1 = text.find(delimiter1);
    }
    return;
  }
};



#endif /* BINTREE_H */
