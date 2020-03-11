using Microsoft.Xna.Framework;
using On_the_Horizon;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace On_the_Horizon
{
    public class World
    {
        public Player ed;
        public World()
        {
            ed = new Player("2D\\specialeddie", new Vector2(300, 300), new Vector2(64, 64));
        }

        public virtual void Update()
        {
            ed.Update();
        }

        public virtual void Draw(Vector2 offset)
        {
            ed.Draw(offset);
        }
    }
}
