import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ConvertToDiagram {

  private static Node findParent(Node prevNode, int currLevel) {
    Node temp = prevNode;
    while(temp != null) {
      if(temp.level == currLevel -1) return temp;
      temp = temp.parent;
    }
    return null;
  }

  public static Node extractOutline(String orgText) {
    String[] lines = orgText.split("\n");

    Node root = new Node();

    Node prevNode = root;
    StringBuilder bodyText = new StringBuilder();
    for (String line : lines) {
//      System.out.println(line);
      String trimmedLine = line.trim();
      if (trimmedLine.length() == 0) continue;

      Pattern blockPattern = Pattern.compile("^#\\+(.*)$");
      Matcher blockMatcher = blockPattern.matcher(trimmedLine);

      if(blockMatcher.matches()) continue;

      Pattern headingPattern = Pattern.compile("^(\\*+)(.*)$");
      Matcher headingMatcher = headingPattern.matcher(trimmedLine);


      boolean isHeading = headingMatcher.matches();
      String value = isHeading ? headingMatcher.group(2).trim() : trimmedLine;
      NodeType nodeType = isHeading ? NodeType.TITLE : NodeType.BODY;
      int currLevel = isHeading ? headingMatcher.group(1).length() : prevNode.level + 1;

      if(!isHeading) {
        bodyText.append(value).append("\n");
        continue;
      }

      if(bodyText.length() != 0) {
        Node curr = new Node(prevNode, currLevel, bodyText.toString(), NodeType.BODY);
        prevNode.addChild(curr);
        bodyText = new StringBuilder();
      }
      Node parentNode = findParent(prevNode, currLevel);
      Node curr = new Node(parentNode, currLevel, value, nodeType);
      parentNode.addChild(curr);
      prevNode = curr;
    }

    return root;
  }

  public static void main(String[] args) {
    String filePath = "/Users/kartik.yadav/App/notes/notes/resources/books/crackingTheTechCareer/annotation.org";

    try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
      StringBuilder orgText = new StringBuilder();
      String line;

      while ((line = reader.readLine()) != null) {
        orgText.append(line).append("\n");
      }

      Node root = extractOutline(orgText.toString());

      System.out.println("printing nodes");

      StringBuilder ans = new StringBuilder("flowchart TD \n");
      convert(root, ans);
      System.out.println(ans);
//      printNode(root);

    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  public static void printNode(Node p) {
    System.out.println(p.value);

    for (Node c : p.childs) {
      System.out.println(p.value + "--->" + c.value);
      printNode(c);
    }
  }

  private static String getEdge(Node parent) {
    int defaultLength = 2;
//    if(parent == null) return "-".repeat(2);
//    return "-".repeat(2+(parent.childs.size()/2));
    return "-".repeat(3);
  }
  public static StringBuilder convert(Node p, StringBuilder ans) {
    if (p == null) return ans;
    if(p.id.equals("0")) {
      for (Node c : p.childs) {
        convert(c, ans);
      }
      return ans;
    }
    ans.append(p.id + "[\"" + p.value + "\"]\n");
    Node parent = p.parent;
    String parentId = "";
    if (parent != null && parent.id != "0") {
      parentId = parent.id;
    }
    if(parentId != "") {
      ans.append(parentId).append(getEdge(parent)).append(Objects.equals(p.type.toString(), NodeType.TITLE.toString()) ? ">" : "o").append(p.id).append("\n");
    }
    for (Node c : p.childs) {
      convert(c, ans);
    }
    return ans;
  }
}

enum NodeType {
  TITLE, BODY
}

class Node {
  public Node parent;
  public List<Node> childs;
  public int level;
  public String value;
  public String id;
  public NodeType type;

  Node() {
    this.childs = new ArrayList<>();
    this.parent = null;
    this.value = null;
    this.level = 0;
    this.id = "0";
    this.type = NodeType.TITLE;
  }

  Node(Node p, int l, String value, NodeType t) {
    this.parent = p;
    this.level = l;
    this.value = value;
    this.childs = new ArrayList<>();
    this.id = (p.id.equals("0") ? "" : (p.id + ".")) + Integer.toString(p.childs.size() + 1);
    this.type = t;
  }

  public void addChild(Node c) {
    childs.add(c);
  }
}
