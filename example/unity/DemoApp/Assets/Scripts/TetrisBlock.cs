using System.Collections.Generic;
using FlutterUnityIntegration;
using UnityEngine;

public class TetrisBlock : MonoBehaviour
{
    public Vector3 rotationPoint;
    private float previousTime;
    public float fallTime = 0.8f;
    public static int height = 20;
    public static int width = 10;
    private static Transform[,] grid = new Transform[width, height];
    private int score = 0;
    private const int ROW_SCORE = 5;
    private const float SHOW_RESULTS_TIME = 5f;
    private const float RESTART_TIME = 1f;
    private bool isFailedBlock;
    
    void Awake()
    {
        if (ValidMove() == false)
        {
            isFailedBlock = true;
            Invoke(nameof(Restart), SHOW_RESULTS_TIME);
        }
    }

    void Restart()
    {
        this.enabled = false;
        List<GameObject> parents =  new List<GameObject>();
        for(int j = 0; j< width; j++)
        {
            for(int i = 0; i< height; i++)
            {
                if (grid[j, i] == null)
                {
                    continue;
                }
                else
                {
                    Destroy(grid[j, i].gameObject);
                    if(grid[j, i].gameObject.transform.parent != null && parents.Contains(grid[j, i].gameObject.transform.parent.gameObject) == false)
                        parents.Add(grid[j, i].gameObject.transform.parent.gameObject);
                }
            }
        }

        foreach (var parent in parents.ToArray())
        {
            Destroy(parent);
        }
        
        score = 0;
        UnityMessageManager.Instance.SendMessageToFlutter(score.ToString());
        FindObjectOfType<SpawnTetromino>().NewTetromino(RESTART_TIME);
        Destroy(this.gameObject);
    }

    void Rotate()
    {
        transform.RotateAround(transform.TransformPoint(rotationPoint), new Vector3(0,0,1), 90);
        if (!ValidMove())
            transform.RotateAround(transform.TransformPoint(rotationPoint), new Vector3(0, 0, 1), -90);    
    }

    void MoveLeft()
    {
        transform.position += new Vector3(-1, 0, 0);
        if(!ValidMove())
            transform.position -= new Vector3(-1, 0, 0);
    }

    void MoveRight()
    {
        transform.position += new Vector3(1, 0, 0);
        if (!ValidMove())
            transform.position -= new Vector3(1, 0, 0);
    }

    // Update is called once per frame
    void Update()
    {
        if (isFailedBlock)
            return;
        
        bool isPressingDown = Input.GetKey(KeyCode.DownArrow);
        
        if ((Input.touchCount > 0) /*||
            Input.GetMouseButtonDown(0)*/)
        {
            var mousePos = Input.mousePosition;
            var mouseWorld = Camera.main.ScreenToWorldPoint(mousePos);

            bool tappedAnyChildren = false;
            
            foreach (Transform children in transform)
            {
                int roundedX = Mathf.RoundToInt(children.transform.position.x);
                int roundedY = Mathf.RoundToInt(children.transform.position.y);
                if (Mathf.Abs(mouseWorld.x - roundedX) < 0.5 &&
                    Mathf.Abs(mouseWorld.y - roundedY) < 0.5)
                {
                    if(Input.GetTouch(0).phase == TouchPhase.Ended)
                        tappedAnyChildren = true;
                    break;
                }
            }
            
            if(tappedAnyChildren) Rotate();
            else
            {
                if (mouseWorld.x >= transform.position.x)
                {
                    if(Input.GetTouch(0).phase == TouchPhase.Ended)
                        MoveRight();
                }
                if (mouseWorld.x <= transform.position.x)
                {
                    if(Input.GetTouch(0).phase == TouchPhase.Ended)
                        MoveLeft();
                }
                if (mouseWorld.y < transform.position.y)
                {
                    isPressingDown = true;
                }
            }
        }
        
        if(Input.GetKeyDown(KeyCode.LeftArrow))
        {
            MoveLeft();
        }
        else if (Input.GetKeyDown(KeyCode.RightArrow))
        {
           MoveRight();
        }
        else if (Input.GetKeyDown(KeyCode.UpArrow))
        {
            Rotate();
        }

        var actualFallTime = isPressingDown ? fallTime / 10 : fallTime;
        
        if (Time.time - previousTime > actualFallTime)
        {
            transform.position += new Vector3(0, -1, 0);
            if (!ValidMove())
            {
                transform.position -= new Vector3(0, -1, 0);
                AddToGrid();
                CheckForLines();

                this.enabled = false;
                FindObjectOfType<SpawnTetromino>().NewTetromino(0f);

            }
            previousTime = Time.time;
        }
    }

    void CheckForLines()
    {
        for (int i = height-1; i >= 0; i--)
        {
            if(HasLine(i))
            {
                DeleteLine(i);
                score += ROW_SCORE;
                UnityMessageManager.Instance.SendMessageToFlutter(score.ToString());
                RowDown(i);
            }
        }
    }

    bool HasLine(int i)
    {
        for(int j = 0; j< width; j++)
        {
            if (grid[j, i] == null)
                return false;
        }

        return true;
    }

    void DeleteLine(int i)
    {
        for (int j = 0; j < width; j++)
        {
            Destroy(grid[j, i].gameObject);
            grid[j, i] = null;
        }
    }

    void RowDown(int i)
    {
        for (int y = i; y < height; y++)
        {
            for (int j = 0; j < width; j++)
            {
                if(grid[j,y] != null)
                {
                    grid[j, y - 1] = grid[j, y];
                    grid[j, y] = null;
                    grid[j, y - 1].transform.position -= new Vector3(0, 1, 0);
                }
            }
        }
    }
    
    void AddToGrid()
    {
        foreach (Transform children in transform)
        {
            int roundedX = Mathf.RoundToInt(children.transform.position.x);
            int roundedY = Mathf.RoundToInt(children.transform.position.y);

            grid[roundedX, roundedY] = children;
        }
    }

    bool ValidMove()
    {
        foreach (Transform children in transform)
        {
            int roundedX = Mathf.RoundToInt(children.transform.position.x);
            int roundedY = Mathf.RoundToInt(children.transform.position.y);

            if(roundedX < 0 || roundedX >= width || roundedY < 0 ||roundedY >= height)
            {
                return false;
            }

            if (grid[roundedX, roundedY] != null)
                return false;
        }

        return true;
    }
}
